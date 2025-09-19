## SSL Certificates Creation with OpenSSL tool:

**Commads**:
```
openssl genrsa -out infraautomate.key 2048
   
openssl req -new -key infraautomate.key -out infraautomate.csr

openssl x509 -req -days 365 -in infraautomate.csr -signkey infraautomate.key -out infraautomate.crt

openssl pkcs12 -export -out infraautomate.pfx -inkey infraautomate.key -in infraautomate.crt -passout pass:Bbpl@#2304

```

**Optional when need**:

`openssl pkcs12 -export -out infraautomate.pfx -inkey infraautomate.key -in infraautomate.crt -certfile infraautomate.crt -passout pass:Bbpl@#2304`
  
  
     