# Sinatra Boilerplate v3

Instalar dependencias:

    $ bundler install

Ejecutar aplicación:

    $ puma

Ejecutar aplicación hot-reaload:

    $ rerun puma --ignore "public/*"

### Mmigraciones

Migraciones con DBMATE - access:

    $ dbmate -d "db/migrations" -e "DATABASE_URL" new <<nombre_de_migracion>>
    $ dbmate -d "db/migrations" -e "DATABASE_URL" up

---

Fuentes:

+ https://blog.carbonfive.com/2013/06/24/sinatra-best-practices-part-one/
+ https://stackoverflow.com/questions/735073/best-way-to-require-all-files-from-a-directory-in-ruby
