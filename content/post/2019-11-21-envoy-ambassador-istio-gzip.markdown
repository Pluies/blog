---
author: Florent
date: 2019-11-22 11:20:37+00:00
draft: false
title: "Envoy, Ambassador and Istio: a gzip adventure"
type: post
url: /blog/2019/envoy-ambassador-istio-gzip/
---

[HTTP compression](https://en.wikipedia.org/wiki/HTTP_compression) is ubiquitous on the modern web as a way to trade a small amount of computing power in exchange for vastly reduced bandwidth. It is usually achieved with the `gzip` algorithm, so I'll refer to HTTP compression and gzip compression interchangeably in this post.

YNAP uses compression across the board to load pages faster, which makes users happier, and reduce bandwidth costs, which makes the finance department happier.

When we set up a new Kubernetes-based infrastructure for public-facing websites, we started using [Ambassador](https://www.getambassador.io/) as a reverse-proxy for all inbound HTTP calls, and [Istio](https://istio.io/) as a service mesh. Under the hood, both of these projects use the open-source [Envoy](https://www.envoyproxy.io/) reverse-proxy, originally developed at Lyft.

This setup has proved to be extremely flexible and performant, and after ironing out a few kinks we've been really happy with it.

However, after migrating a few countries, monitoring showed that our average page size and outbound traffic had grown a sizeable bit, which couldn't be explained by the application payload: it had to be infrastructure-related. After investigating, we found out that gzip compression was much worse on the new stack than it was on the older stack.

... And that was despite the older stack not having gzip compression enabled at all!

Enter Akamai
------------

We use [Akamai](https://www.akamai.com/) as a Content Delivery Network. All calls to our infrastructure first go through Akamai, which ensures faster delivery thanks to having PoPs much closer to clients than our servers could be, and adds extra features like protection against DDOS attacks, caching, etc.

Akamai's coverage is... Extensive:

<img src="/images/akamai.png" alt="Akamai POPs" style="width: 100%;">
<p style="text-align: center;">_Do <u>you</u> have servers [in Antarctica?](https://www.akamai.com/uk/en/solutions/intelligent-platform/visualizing-akamai/media-delivery-map.jsp)_</p>


And, crucially... When a client supports compression, and the response that Akamai receives from our origin servers is not compressed, it will go ahead and compress it before returning it to the client. However, if the response from the origin server is _already_ compressed, Akamai will send it to the client as-is: compression twice is useless, and decompressing + recompressing every request is wasteful.

So, counter-intuitively, enabling gzip compression on our origin backends made compression worse for the clients, as Akamai had better compression performance. We could have just deactivated gzip compression altogether on our origin servers and relied on Akamai to do it, but we also wanted to reduce bandwidth between origin servers and Akamai.

So we decided to investigate: what is wrong with our own gzip compression?!

Gzip measurements & parameter tuning
------------------------------------

We wrote a small benchmark to examine the compression ratio of various reverse-proxies to see:

- If the issue we were facing was specific to Ambassador/Envoy
- What compression options had an impact
- How the competitors stacked up

The benchmark's source and instructions to reproduce can be found on Github: [https://github.com/Pluies/gzip-comparison](https://github.com/Pluies/gzip-comparison)

And here is a representative sample:

```
~/projects/gzip-comparison λ ./compare.sh assets/youtube.com.html
Comparing compression performance for file: assets/youtube.com.html (all sizes in bytes)
origin, uncompressed      247602
nginx, base               45826
nginx, optimised          38924
ambassador, base          55904
ambassador, optimised     55804
envoy, base               55907
envoy, optimised          43763
apache, base              38831
apache, optimised         38972
local gzip, base          39126
local gzip, optimised     38941
```

Or as a graph:

<img src="/images/gzip-bars.png" alt="gzip performance graph" style="width: 100%;">

The results we saw in the live environment for Akamai were identical to optimised Apache / optimised nginx / local CLI.

The two main takeaways from this test:

- Most servers compress gzip at very similar ratios, similar to the stand-alone gzip utility
- Ambassador produced files *40% larger* than most servers, even "optimised"!

Using Envoy directly, we were able to reduce the size by setting the [`window_bits` parameter](https://www.envoyproxy.io/docs/envoy/latest/api-v2/config/filter/http/gzip/v2/gzip.proto.html) to `15`, which produced compressed files about 10% larger than other servers. Still not ideal, but a sizeable improvement.

We also started using this configuration in our Istio mesh to enable compression as widely as possible.

Ambassador did not expose this setting, but it is open-source! We opened [pull request #1890](https://github.com/datawire/ambassador/pull/1890) which got merged within a few days. 🎉

Envoy and gzip
--------------

Even after tuning all available parameters, we are still left with a ~10 to 12% performance degradation by using Envoy, compared to virtually all other options tested.

We've opened [Envoy issue #8448](https://github.com/envoyproxy/envoy/issues/8448) to report back our findings, with benchmark results. This is treated as a bug, and hopefully will be fixed in the future 🤞
