---
author: Florent
date: 2012-02-09 11:23:17+00:00
draft: false
title: Format perlcritic output as TAP to integrate with Jenkins
type: post
url: /blog/2012/format-perlcritic-output-as-tap-to-integrate-with-jenkins/
categories:
- Programming
tags:
- jenkins
- perlcritic
- testing
---

[Perl::Critic](http://search.cpan.org/~thaljef/Perl-Critic-1.117/lib/Perl/Critic.pm) is a nifty syntax analyzer able to parse your Perl code, warn you against common mistakes and hint you towards best practices. It's available either as a Perl module or a standalone shell script (perlcritic). Unfortunately, there is no standard way to integrate it with Jenkins.

[Jenkins](http://jenkins-ci.org/), the continuous-integration-tool-formerly-known-as-Hudson, is the cornerstone of our continuous building process at work. It checks out the latest build from Git, runs a bunch of tests (mainly Selenium, as we develop a website) and keeps track of what goes wrong and what goes right. We wanted to integrate Perl::Critic to Jenkins' diagnostics to keep an eye on some errors that could creep in our codebase.

So Jenkins doesn't do Perl::Critic. However, Jenkins supports TAP. [TAP, the Test Anything Protocol](http://testanything.org/), is an awesomely simple format to express test results that goes as follow:

    
    1..4
    ok 1 my first test
    ok 2 another successful test
    not ok 3 oh, this one failed
    ok 4 the last one's ok



The first line (the plan) announces how many tests there are, and each following line is a test result beginning by either "ok" or "not ok" depending on what gave.

Based on such a simple format, we can use a bit of shell scripting to mangle perlcritic's output to be TAP-compatible:

    
    # Perl::Critic                             \
    # with line numbers (nl)...                \
    # prepend 'ok' for passed files...         \
    # and 'not ok' for each error...           \
    # and put everything in a temp file
    
    perlcritic $WORKSPACE                      \
      | nl -nln                                \
      | sed 's/\(.*source OK\)$/ok \1/'        \
      | sed '/source OK$/!s/^.*$/not ok &/'    \
      > $WORKSPACE/perlcritic_tap.results.tmp
    
    # Formatting: add the TAP plan, and output the tap results file.
    # TAP plan is a line "1..N", N being the number of tests
    echo 1..`wc -l < $WORKSPACE/perlcritic_tap.results.tmp` \
     |cat - $WORKSPACE/perlcritic_tap.results.tmp > $WORKSPACE/perlcritic_tap.results
    
    # Cleanup
    rm -f $WORKSPACE/perlcritic_tap.results.tmp



($WORKSPACE is a Jenkins-set variable referring to where the current build is being worked on.)

And voilà! Jenkins reads the TAP result file and everything runs smoothly.

The only downside of this approach is that the number of tests will vary. For example, a single .pm file containing 5 Perl::Critic violations will show up as 5 failed tests, but fixing these will turn into a single successful test.
