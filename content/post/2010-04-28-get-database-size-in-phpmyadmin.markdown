---
author: Florent
date: 2010-04-28 19:19:56+00:00
draft: false
title: Get database size in phpMyAdmin
type: post
url: /blog/2010/get-database-size-in-phpmyadmin/
categories:
- UNIX
tags:
- minitip
- phpmyadmin
- sql
---

It looks like phpMyAdmin doesn't include a way to see how much space takes the MySQL database. I found that a bit weird, but hey, if phpMyAdmin doesn't do it, let's cut to the chase and go SQL!

The most straightforward way to get your database size from phpMyAdmin is the following SQL query:

```sql
    SELECT table_schema "Data Base Name",
    sum( data_length + index_length ) / 1024 / 1024 "Data Base Size in MB"
    FROM information_schema.TABLES GROUP BY table_schema ;
```


Originally from [the MySQL forums](http://forums.mysql.com/read.php?108,201578,201578).
