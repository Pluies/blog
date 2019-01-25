---
author: Florent
date: 2019-01-25 17:09:10+00:00
draft: false
title: Azure AD broke OIDC in Kubernetes 1.9
type: post
url: /blog/2019/azure-ad-broke-kubernetes-1-9-oidc/
---

We recently got bitten by an innocent and standards-compliant improvement in Azure AD that effectively broke our OIDC-based authentication system for Kubernetes 1.9.x clusters.

OIDC, short for OpenID Connect, is [a convenient way of providing authentication in Kubernetes](https://kubernetes.io/docs/reference/access-authn-authz/authentication/#openid-connect-tokens). The flow roughly goes as follows:

1. User gets a JWT token from its OIDC provider (Azure AD)
2. User sends this token to Kubernetes alongside its request
3. Kubernetes validates this token by verifying the JWT signature against the provider's public key
4. Kubernetes lets the authenticated request through

This theoretically ensures Kubernetes doesn't need to "phone home" by calling the authN provider for every request, as happens for example under the [Webhook Token authentication](https://kubernetes.io/docs/reference/access-authn-authz/authentication/#webhook-token-authentication) mode.

However... Kubernetes must still call this provider to retrieve its public key. Otherwise, it has no way of validating the authenticity of the JWT token.

The provider's public keys are found through the [OIDC Discovery protocol](https://openid.net/specs/openid-connect-discovery-1_0.html), which defines `/.well-known/openid-configuration` as the HTTP URL that Kubernetes must hit to retrieve the public keys. In Azure AD, this translates to:

[https://login.microsoftonline.com/{tenant}/v2.0/.well-known/openid-configuration](https://login.microsoftonline.com/{tenant}/v2.0/.well-known/openid-configuration)

Or for a working example, the common config at:

[https://login.microsoftonline.com/common/v2.0/.well-known/openid-configuration](https://login.microsoftonline.com/common/v2.0/.well-known/openid-configuration).

This setup has worked extremely well for us, once we managed to get the configuration just right... Until one day, we could not log into our Kubernetes clusters through OIDC anymore, and saw the following error messages in the apiserver:

```
[oidc.go:178] oidc authenticator: failed to fetch provider discovery data: parsing time "-1" as "Mon, 02 Jan 2006 15:04:05 MST": cannot parse "-1" as "Mon"
```

The change
----------

The innocuous change that Azure made was to add the following headers to the HTTP response:

```
Cache-Control: max-age
Expires: -1
```

The aim of these headers is to signify that the caller is allowed to cache this response until the timestamp defined in `Expires`, which is typically set in the future, cf. [RFC 7234](https://tools.ietf.org/html/rfc7234#page-28):
```
   The Expires value is an HTTP-date timestamp, as defined in Section
   7.1.1.1 of [RFC7231].

     Expires = HTTP-date

   For example

     Expires: Thu, 01 Dec 1994 16:00:00 GMT
```

By setting the `Expires` to `-1`, Azure tells the caller to _not_ cache the results of this call at all. As per the RFC again:

```
   A cache recipient MUST interpret invalid date formats, especially the
   value "0", as representing a time in the past (i.e., "already
   expired").
```

Why does it break?
------------------

Azure AD's change being RFC-conformant you'd expect Kubernetes to be able to handle it nicely. However, before Kubernetes 1.10, Kubernetes was using version 1.x of the [coreos/go-oidc](https://github.com/coreos/go-oidc) provider, which embeds its own HTTP client instead of using Go's default HTTP client.

This client doesn't deal very well with cache headers, and a variant of this very issue was raised as [issue #136](https://github.com/coreos/go-oidc/issues/136) on Github. It got fixed by [treating 0 as a special-case value for the Expires header](https://github.com/coreos/go-oidc/pull/153).

While a step in the right direction, this is still not RFC-compliant, as the RFC states that _any_ invalid date format must be interpreted as a time in the past, not just the string `0`.

The fix
-------

Kubernetes 1.9 is EOL since the release of Kubernetes 1.13 on Dec 3rd 2018, so I have little hope of a fix actually happening for this version. The best fix for this is simply to upgrade to Kubernetes >= 1.10.

Kubernetes 1.10 onwards uses go-oidc v2.x, which uses Go's HTTP client, which deals with cache headers properly.

*Note*: we hit this issue in December 2018, but at the time of writing up this blog post (January 2019), I cannot reproduce the `Expires` headers in response to the well-known OIDC discovery requests, so Azure _might_ have rolled these changes back, or they might not yet have been pushed in this region. We did notice the changes happening on different days depending on the AWS region that the cluster was running into, so this has been a gradual rollout.
