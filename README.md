# ChatApp-FC
This is my version of Flash Chat App of London Brewery App with Supabase and my own Back-End PHP resources. 70

# lib/secret.dart
Please put this code in you chatapp/db.inc.php

```
import 'package:flutter/material.dart';

const supabase_url='<your supabase url>';
const anon_key = '<your supabase anon key>';


String message_url =
    'your back-end message URL';
String signature_url = "y back-end message signature url";


```

# images/
Please put 2 image files in your images directory. The prefereable size is 600x600.

```
logo.png
logo2.png
```
# Todo
- Avatar image file upload. (Done)
- Message expire algorithm
- Create group 

