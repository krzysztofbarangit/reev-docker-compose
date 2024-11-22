# Changelog

## [0.7.0](https://github.com/bihealth/reev-docker-compose/compare/v0.6.0...v0.7.0) (2024-11-22)


### Features

* Add V_HPO_ANNONARS_GENES  ([#59](https://github.com/bihealth/reev-docker-compose/issues/59)) ([402b256](https://github.com/bihealth/reev-docker-compose/commit/402b256823cf978dbe83f042c41c452ebaae7d1e))
* bump annonars/genes ([#53](https://github.com/bihealth/reev-docker-compose/issues/53)) ([b099172](https://github.com/bihealth/reev-docker-compose/commit/b09917215d4e57ed7284cc1ff75bc33baf98eeb0))
* bump to clinvar build for 2024-05-28 ([#60](https://github.com/bihealth/reev-docker-compose/issues/60)) ([6e6cfaf](https://github.com/bihealth/reev-docker-compose/commit/6e6cfafc29585ae9aac98a07d9c174e7123a32bf))
* Integrate AutoACMG microservice ([#66](https://github.com/bihealth/reev-docker-compose/issues/66)) ([#67](https://github.com/bihealth/reev-docker-compose/issues/67)) ([50bb8fd](https://github.com/bihealth/reev-docker-compose/commit/50bb8fdc4729e61c27cfeae4bfe3eae12a136a41))
* update version of clinvar to 20240503 ([#58](https://github.com/bihealth/reev-docker-compose/issues/58)) ([7ddfe8d](https://github.com/bihealth/reev-docker-compose/commit/7ddfe8de214a0e4bf15849f590a1c4c86c5267b5))


### Bug Fixes

* adding hgnc_xlink.tsv for viguno ([#64](https://github.com/bihealth/reev-docker-compose/issues/64)) ([8bd5191](https://github.com/bihealth/reev-docker-compose/commit/8bd5191e0bb1b56a48be1f1a219fd040fc027aa4))
* bump mehari-data-tx to 0.6.0 ([#55](https://github.com/bihealth/reev-docker-compose/issues/55)) ([97924e6](https://github.com/bihealth/reev-docker-compose/commit/97924e65a9154951fb91d064335b75b62dcd9d19))
* hpo xlink path for viguno ([#65](https://github.com/bihealth/reev-docker-compose/issues/65)) ([ec1bdfa](https://github.com/bihealth/reev-docker-compose/commit/ec1bdfad138343fdef5341eb7ab8eafd29cb7a0f))
* Remove autoacmg settings from tpl ([#69](https://github.com/bihealth/reev-docker-compose/issues/69)) ([daa2467](https://github.com/bihealth/reev-docker-compose/commit/daa24675752d4dae66f44a0974236a6cbda62ff2))

## 0.6.0 (2024-02-08)


### Features

* add celery worker and beat containers ([#38](https://www.github.com/bihealth/reev-docker-compose/issues/38)) ([#39](https://www.github.com/bihealth/reev-docker-compose/issues/39)) ([9774e4e](https://www.github.com/bihealth/reev-docker-compose/commit/9774e4e354554d3e085d38d297a3900920b4acc9))
* add clinvar info to readme ([#1](https://www.github.com/bihealth/reev-docker-compose/issues/1)) ([f9622c6](https://www.github.com/bihealth/reev-docker-compose/commit/f9622c61b1daebef14bc46349a1c9815d9a8e89f))
* adding back redis ([#11](https://www.github.com/bihealth/reev-docker-compose/issues/11)) ([1a3e05a](https://www.github.com/bihealth/reev-docker-compose/commit/1a3e05a45dd54fa8ecb723d2d51be16a3e7bfad2))
* adding cada-prio container ([#23](https://www.github.com/bihealth/reev-docker-compose/issues/23)) ([3f2ddb9](https://www.github.com/bihealth/reev-docker-compose/commit/3f2ddb98feded2a96cacf3111e2b3e8b61506d8e))
* Allow downloading the data without ssl certificate verification ([#43](https://www.github.com/bihealth/reev-docker-compose/issues/43)) ([#44](https://www.github.com/bihealth/reev-docker-compose/issues/44)) ([536f539](https://www.github.com/bihealth/reev-docker-compose/commit/536f53990676f414e7f55be1b572a4ca422f3092))
* bash script to download data ([#42](https://www.github.com/bihealth/reev-docker-compose/issues/42)) ([9889ccb](https://www.github.com/bihealth/reev-docker-compose/commit/9889ccbd930ac5ebf77f7661899ba0754ed5d840))
* enable redis and postgres in docker-compose.override.yml-dev ([#7](https://www.github.com/bihealth/reev-docker-compose/issues/7)) ([042eaa7](https://www.github.com/bihealth/reev-docker-compose/commit/042eaa77cca2176b230a3a2bc1081d03453bd9cf))
* expossing pgadmin, improving docs ([#12](https://www.github.com/bihealth/reev-docker-compose/issues/12)) ([b8259c2](https://www.github.com/bihealth/reev-docker-compose/commit/b8259c2c7961be5edc440cc712449b289c1c8422))
* integrate dotty for c./n./g. resolution to SPDI ([#16](https://www.github.com/bihealth/reev-docker-compose/issues/16)) ([42e79bd](https://www.github.com/bihealth/reev-docker-compose/commit/42e79bdf86d1b12a4da31ad5c005d7edfd75f0b1))
* let reev container wait for others ([#6](https://www.github.com/bihealth/reev-docker-compose/issues/6)) ([3fa108d](https://www.github.com/bihealth/reev-docker-compose/commit/3fa108db62707adb2ae00f7611e7136bcf5dfe46))
* switching to rabbitmq, adding flower and pgadmin ([#9](https://www.github.com/bihealth/reev-docker-compose/issues/9)) ([7c5b1d4](https://www.github.com/bihealth/reev-docker-compose/commit/7c5b1d4f1d98e05a621cae90e78f3e2a14b88f39))
* update annonars/genes to 3.1+4.0+4.5+20240116+20240119+0.3 ([#45](https://www.github.com/bihealth/reev-docker-compose/issues/45)) ([170bfb0](https://www.github.com/bihealth/reev-docker-compose/commit/170bfb0d7ca70370cf8f30b09b0b07076771d81a))
* updated clinvar data, adding clinvar genes ([#4](https://www.github.com/bihealth/reev-docker-compose/issues/4)) ([4499a9e](https://www.github.com/bihealth/reev-docker-compose/commit/4499a9ea9a95060c0431f509357998d42041b951))


### Bug Fixes

* adjust RabbitMQ in docker-compose.override.yml ([#37](https://www.github.com/bihealth/reev-docker-compose/issues/37)) ([0435b59](https://www.github.com/bihealth/reev-docker-compose/commit/0435b59e1d95924fbf4064f536acb8e46fd5276f))
* Correctly map dotty to localhost port in development yaml file ([#19](https://www.github.com/bihealth/reev-docker-compose/issues/19)) ([1e2a595](https://www.github.com/bihealth/reev-docker-compose/commit/1e2a59577e245fea0d88870be3e1d6d576a9d48f))
* Fix installation of cada-prio data in Readme ([#35](https://www.github.com/bihealth/reev-docker-compose/issues/35)) ([0ad38d5](https://www.github.com/bihealth/reev-docker-compose/commit/0ad38d5b4f33a30868c05e8fba40440e4e960860))
* make reev depend on dotty ([#17](https://www.github.com/bihealth/reev-docker-compose/issues/17)) ([f099916](https://www.github.com/bihealth/reev-docker-compose/commit/f099916391d30c5349aec25fbb4d0dfff8743731))
* mehari 0.4.2 downloads ([#40](https://www.github.com/bihealth/reev-docker-compose/issues/40)) ([d9d517c](https://www.github.com/bihealth/reev-docker-compose/commit/d9d517c36a83021b6daf1a8a9f2bf400a27bfee5))
* missing postgres/redis volumes ([#8](https://www.github.com/bihealth/reev-docker-compose/issues/8)) ([d15fdda](https://www.github.com/bihealth/reev-docker-compose/commit/d15fddac11ef0e6b7c59d208577b29867fe89b1f))
* Proper naming of cada-prio container ([#24](https://www.github.com/bihealth/reev-docker-compose/issues/24)) ([872ee86](https://www.github.com/bihealth/reev-docker-compose/commit/872ee86db572b29df0b215f229fe35f8557ad352))
* put nginx container into reev network ([#18](https://www.github.com/bihealth/reev-docker-compose/issues/18)) ([c913585](https://www.github.com/bihealth/reev-docker-compose/commit/c91358525397068be865d614400ec82e3c0ab13c))
* Readme bash session blocks are not properly displayed ([#5](https://www.github.com/bihealth/reev-docker-compose/issues/5)) ([93409c7](https://www.github.com/bihealth/reev-docker-compose/commit/93409c716945d2350321b435a8ddd9061a65c1cb))
* some updates for production deployment ([#13](https://www.github.com/bihealth/reev-docker-compose/issues/13)) ([38aa465](https://www.github.com/bihealth/reev-docker-compose/commit/38aa46591ce00f0fcf28f435860f8db6ef564ff9))


### Miscellaneous Chores

* update next version to v0.6.0 ([cc7ab85](https://www.github.com/bihealth/reev-docker-compose/commit/cc7ab85a23d0a76be582ce6d79bfe7904daf0f57))
