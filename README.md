sape.ru-scripts
===============

Скрипты, использующие API sape.ru

* sape_delete_old_SEO_WAIT_links.pl - скрипт, удаляющий ссылки со статусом WAIT_SEO, время ожидания по которым превышает заданное.

Использование:

cp config.pl.sample config.pl

Отредактируйте config.pl: введите свой логин, хеш пароля и задайте максимальное время ожидания для ссылок (по умолчанию - 3 суток).

./sape_delete_old_SEO_WAIT_links.pl
