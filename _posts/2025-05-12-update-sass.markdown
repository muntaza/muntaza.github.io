---
layout: post
title:  "Update file scss di jekyll"
date:   2025-05-12 03:26:56 +0800
categories: jekyll
---

# Bismillah,

Terdapat update file scss pada [jekyll](https://github.com/jekyll/jekyll/issues/9686) diantaranya 
penggunaan fungsi calc dan penggunaan fungsi color. Di bawah ini tampilan diff setelah perubahan:

```text
diff --git a/_sass/_base.scss b/_sass/_base.scss
index 5500958..b748b5d 100644
--- a/_sass/_base.scss
+++ b/_sass/_base.scss
@@ -1,3 +1,5 @@
+@use "sass:color";
+
 /**
  * Reset some basic elements
  */
@@ -34,7 +36,7 @@ h1, h2, h3, h4, h5, h6,
 p, blockquote, pre,
 ul, ol, dl, figure,
 %vertical-rhythm {
-    margin-bottom: $spacing-unit / 2;
+    margin-bottom: calc($spacing-unit / 2);
 }
 
 
@@ -95,7 +97,7 @@ a {
     text-decoration: none;
 
     &:visited {
-        color: darken($brand-color, 15%);
+        color: color.adjust($brand-color, $lightness: -15%, $space: hsl);
     }
 
     &:hover {
@@ -112,7 +114,7 @@ a {
 blockquote {
     color: $text-color;
     border-left: 4px solid $grey-color-light;
-    padding-left: $spacing-unit / 2;
+    padding-left: calc($spacing-unit / 2);
     font-size: 22px;
     letter-spacing: -1px;
     font-style: italic;
@@ -167,8 +169,8 @@ pre {
     @include media-query($on-laptop) {
         max-width: -webkit-calc(#{$content-width} - (#{$spacing-unit}));
         max-width:         calc(#{$content-width} - (#{$spacing-unit}));
-        padding-right: $spacing-unit / 2;
-        padding-left: $spacing-unit / 2;
+        padding-right: calc($spacing-unit / 2);
+        padding-left: calc($spacing-unit / 2);
     }
 }
 
diff --git a/_sass/_layout.scss b/_sass/_layout.scss
index 9cbfdde..75c12d5 100644
--- a/_sass/_layout.scss
+++ b/_sass/_layout.scss
@@ -45,7 +45,7 @@
     @include media-query($on-palm) {
         position: absolute;
         top: 9px;
-        right: $spacing-unit / 2;
+        right: calc($spacing-unit / 2);
         background-color: $background-color;
         border: 1px solid $grey-color-light;
         border-radius: 5px;
@@ -104,7 +104,7 @@
 
 .footer-heading {
     font-size: 18px;
-    margin-bottom: $spacing-unit / 2;
+    margin-bottom: calc($spacing-unit / 2);
 }
 
 .contact-list,
@@ -116,14 +116,14 @@
 .footer-col-wrapper {
     font-size: 15px;
     color: $grey-color;
-    margin-left: -$spacing-unit / 2;
+    margin-left: calc(-1 * $spacing-unit / 2);
     @extend %clearfix;
 }
 
 .footer-col {
     float: left;
-    margin-bottom: $spacing-unit / 2;
-    padding-left: $spacing-unit / 2;
+    margin-bottom: calc($spacing-unit / 2);
+    padding-left: calc($spacing-unit / 2);
 }
 
 .footer-col-1 {
diff --git a/css/main.scss b/css/main.scss
index 6888c1e..236851f 100644
--- a/css/main.scss
+++ b/css/main.scss
@@ -2,6 +2,7 @@
 # Only the main Sass file needs front matter (the dashes are enough)
 ---
 @charset "utf-8";
+@use "sass:color";
 
 
 
@@ -19,8 +20,8 @@ $background-color: #fdfdfd;
 $brand-color:      #2a7ae2;
 
 $grey-color:       #828282;
-$grey-color-light: lighten($grey-color, 40%);
-$grey-color-dark:  darken($grey-color, 25%);
+$grey-color-light: color.adjust($grey-color, $lightness: 40%);
+$grey-color-dark: color.adjust($grey-color, $lightness: -25%);
 
 // Width of the content area
 $content-width:    800px;


```

Demikian catatan ini.

# Alhamdulillah
