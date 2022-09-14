## [2.39.0-next.1](https://github.com/provusinc/quoting/compare/v2.38.0...v2.39.0-next.1) (2022-09-14)


### Features

* **psq-5864:** add header label for based on field in volume discoun… ([#1516](https://github.com/provusinc/quoting/issues/1516)) ([5bc76e8](https://github.com/provusinc/quoting/commit/5bc76e83c689651f6d7157f8974d4673e5885b3f))
* **psq-5865:** remove the active tier and based on columns ([#1513](https://github.com/provusinc/quoting/issues/1513)) ([d6b0791](https://github.com/provusinc/quoting/commit/d6b07914a201f61a30f2404b45fb8bdb7e363339))
* **psq-5866:** rename volume discount column labels ([#1511](https://github.com/provusinc/quoting/issues/1511)) ([be5f6ca](https://github.com/provusinc/quoting/commit/be5f6ca8f758f7746a9451ff38d09f47bb9dcb5e))
* **psq-5867, psq-5870:** return only discount amount in vol discounts ([#1517](https://github.com/provusinc/quoting/issues/1517)) ([3beecfd](https://github.com/provusinc/quoting/commit/3beecfd9efe70f30fef07871ff542fd38e657c1c))
* **psq-5891:** updated radio button labels ([#1518](https://github.com/provusinc/quoting/issues/1518)) ([b8eb5f0](https://github.com/provusinc/quoting/commit/b8eb5f0883312c08706806d6f8d1660c374ab5f5))


### Bug Fixes

* **psq-5855:** recalculate durations for N/A when formulas is enabled ([#1515](https://github.com/provusinc/quoting/issues/1515)) ([a9c1e57](https://github.com/provusinc/quoting/commit/a9c1e57a453972bf04b5a2c34e28fe31e91da696))
* remove imports which are not used ([bc8a10e](https://github.com/provusinc/quoting/commit/bc8a10eddf79d4696a84c35c1924a4e42c41fd28))

## [2.38.0](https://github.com/provusinc/quoting/compare/v2.37.3...v2.38.0) (2022-09-14)


### Features

* **custom labels:** fix dupe custom labels ([55199ff](https://github.com/provusinc/quoting/commit/55199ff5f7293ce80c92a97779491878b4aaef63))
* **estimator:** initial rewrite ([71f7a2f](https://github.com/provusinc/quoting/commit/71f7a2f3ec208ae376e51490e604db9dcdb7710d))
* **estimator:** initial rewrite ([4419c44](https://github.com/provusinc/quoting/commit/4419c443871ad0cf3ac77466e820ff84d98eb27f))
* **pspq-5727:** add data model and layouts for clone settings ([#1472](https://github.com/provusinc/quoting/issues/1472)) ([1e6ecb6](https://github.com/provusinc/quoting/commit/1e6ecb6d8746f67b118e6949c59bef845c654cce))
* **psq-4813:** added unittest and removed generation code ([760260a](https://github.com/provusinc/quoting/commit/760260a8c4d839a7de5d3dfb3deacb1ecdeaec38))
* **psq-4813:** updated test to account for quote id ([a1f8b95](https://github.com/provusinc/quoting/commit/a1f8b951bb46b0ae97db6d85f2bf4c67832fc27a))
* **psq-4947:** disable proposal sync when disable automatic opp sync ([#1451](https://github.com/provusinc/quoting/issues/1451)) ([611f2ba](https://github.com/provusinc/quoting/commit/611f2badfa314c8dd3d1f50a19e746a8f8679616))
* **psq-5518:** estimator rewrite scope summary ([#1439](https://github.com/provusinc/quoting/issues/1439)) ([ce09220](https://github.com/provusinc/quoting/commit/ce092207f8ea6ff2ec3dbc14d09de25b156a5bcc))
* **psq-5522:** conditional show estimate level buttons in new estimator ([#1450](https://github.com/provusinc/quoting/issues/1450)) ([8f3ab4b](https://github.com/provusinc/quoting/commit/8f3ab4b6889055e8aa73e01bd1668fafcb4caafe))
* **psq-5563:** created lwc for save as template dialog ([#1425](https://github.com/provusinc/quoting/issues/1425)) ([e281e18](https://github.com/provusinc/quoting/commit/e281e180eef4da08910752f998223dfd693e4771))
* **psq-5621:** handle calculated duration in new estimator ([#1433](https://github.com/provusinc/quoting/issues/1433)) ([1c27fec](https://github.com/provusinc/quoting/commit/1c27fec8a098285e2498912d611aadcc124b2441))
* **psq-5682:** populated quote total amount from estimate total amount ([#1446](https://github.com/provusinc/quoting/issues/1446)) ([30382de](https://github.com/provusinc/quoting/commit/30382de0a000609df0e618f0eeb52541c01efc9d)), closes [#1425](https://github.com/provusinc/quoting/issues/1425)
* **psq-5685:** estimator rewrite not applicable toggle ([#1447](https://github.com/provusinc/quoting/issues/1447)) ([b8ef809](https://github.com/provusinc/quoting/commit/b8ef8094d3e48bbf2c4881e86a2de1adf10a2152))
* **psq-5709:** validation for improperly formatted formulae ([#1454](https://github.com/provusinc/quoting/issues/1454)) ([71e2c6a](https://github.com/provusinc/quoting/commit/71e2c6a118708e3ea81aae5f7e0ae20f779b6708))
* **psq-5711:** Update the hashtag service if a scope parameter is added or removed ([#1463](https://github.com/provusinc/quoting/issues/1463)) ([ec9883c](https://github.com/provusinc/quoting/commit/ec9883cc0b5d596fc312b0e054d7ba166fba2245))
* **psq-5714, psq-5712, psq-5710:** validate params against dictionary ([#1460](https://github.com/provusinc/quoting/issues/1460)) ([5c7e471](https://github.com/provusinc/quoting/commit/5c7e4711ec892a7ff848eb0b58f71370bb3aa674))
* **psq-5717:** ui should only display and save one volume discount at a time ([#1482](https://github.com/provusinc/quoting/issues/1482)) ([a9aa12e](https://github.com/provusinc/quoting/commit/a9aa12e812355bcbd15fad2c18b05da2f0858eed))
* **psq-5718:** added support to delete volume discounts ([#1476](https://github.com/provusinc/quoting/issues/1476)) ([9e20de5](https://github.com/provusinc/quoting/commit/9e20de54bc2b02d1dcf94f83121df66ed3a50b2f))
* **psq-5721:** data model and page layouts for clone schema definition ([#1468](https://github.com/provusinc/quoting/issues/1468)) ([22ba313](https://github.com/provusinc/quoting/commit/22ba31307314eeae3b3a66ec4251b69a79c8e1dc))
* **psq-5722:** implement cloning service ([#1480](https://github.com/provusinc/quoting/issues/1480)) ([e4bc827](https://github.com/provusinc/quoting/commit/e4bc8271b088735d8edd3dcd6ae055977d37eb1f))
* **psq-5723:** implement preprocessor to return referenced object names ([#1475](https://github.com/provusinc/quoting/issues/1475)) ([b489b66](https://github.com/provusinc/quoting/commit/b489b6684b20544400820e17a1586e53f7421bbe))
* **psq-5724:** unit test sobject cloner ([#1496](https://github.com/provusinc/quoting/issues/1496)) ([d3cc0f6](https://github.com/provusinc/quoting/commit/d3cc0f6997fe9a716d6ffa123d225ef5be0a3728))
* **psq-5726:** feature flag for clone scenario ([#1465](https://github.com/provusinc/quoting/issues/1465)) ([dcf716b](https://github.com/provusinc/quoting/commit/dcf716ba466a947c2dff19b7ce70e83770a7946d))
* **psq-5753:** updated saveTotals to support new pricing beta for adjustments ([#1483](https://github.com/provusinc/quoting/issues/1483)) ([b34b028](https://github.com/provusinc/quoting/commit/b34b028f193e214afc53e364955970b9674db5d2))
* **psq-5782:** introduced feature flag around new pricing changes ([#1470](https://github.com/provusinc/quoting/issues/1470)) ([beef34e](https://github.com/provusinc/quoting/commit/beef34e9db3ce50ecc41602b4d0183b4af8d5df4))
* **psq-5792:** enforce hashtag pattern in scope parameter dialog ([#1469](https://github.com/provusinc/quoting/issues/1469)) ([25f6e3d](https://github.com/provusinc/quoting/commit/25f6e3d177163f7521ac9419c4542a7d26f83de0))
* **psq-5801:** create quote schema data ([#1481](https://github.com/provusinc/quoting/issues/1481)) ([ab7ebd7](https://github.com/provusinc/quoting/commit/ab7ebd72dacb8a45ce5778c2e1c53de25b4f298b))
* **psq-5805:** when no total by value selected should not save volume discount ([#1484](https://github.com/provusinc/quoting/issues/1484)) ([55b029c](https://github.com/provusinc/quoting/commit/55b029cd604199ae89df4b5e395b735f2d22011e))
* **psq-5825:** clone resource availability records when estimate cloned ([#1492](https://github.com/provusinc/quoting/issues/1492)) ([d0846ed](https://github.com/provusinc/quoting/commit/d0846ed9bdb1c2bfbba747e01fa262fd6bcda02b))
* **psq-5826:** non-billable item period group should show zero ([#1489](https://github.com/provusinc/quoting/issues/1489)) ([2c517a3](https://github.com/provusinc/quoting/commit/2c517a3c2835527accd37b316075adcf69cd70a7))
* **psq-5845:** show sync to quote if the quote id exists ([#1499](https://github.com/provusinc/quoting/issues/1499)) ([0a30053](https://github.com/provusinc/quoting/commit/0a30053907bb2915a1d996164b6915e5c65320a7))


### Bug Fixes

* exclude addon item in delta sync estimate to quote flow ([#1507](https://github.com/provusinc/quoting/issues/1507)) ([96fecbf](https://github.com/provusinc/quoting/commit/96fecbf25005815c784af3fd9c8ad00f84bdfaca))
* **psq-5416:** incorrect end date calculated in estimate ([#1436](https://github.com/provusinc/quoting/issues/1436)) ([5d9431a](https://github.com/provusinc/quoting/commit/5d9431a336249e1fe1be63ebc58a77a4c48ddc09))
* **psq-5609:** fix how formula evaluator looks at tokens ([60af566](https://github.com/provusinc/quoting/commit/60af566279ac825a0850ea45bfcda7ae4cd01a77))
* **psq-5631:** contingencies dialog should close when save button clicked ([#1452](https://github.com/provusinc/quoting/issues/1452)) ([8820dd9](https://github.com/provusinc/quoting/commit/8820dd9031da06899b2a0bd8e045b826d02bddea))
* **psq-5640:** task parameter values werent getting copied over ([71274bd](https://github.com/provusinc/quoting/commit/71274bd56ee99ff7a23562f198e3a02272532e06))
* **psq-5669:** fix when decimal falls between tiers ([#1435](https://github.com/provusinc/quoting/issues/1435)) ([2e855e5](https://github.com/provusinc/quoting/commit/2e855e5ddd6c1186c1fc28ca484b363d52f5b56b))
* **psq-5680:** cap period generation to max quote item cell periods ([#1434](https://github.com/provusinc/quoting/issues/1434)) ([972f263](https://github.com/provusinc/quoting/commit/972f26356e58964047df81009bbdb240420e0b82))
* **psq-5681:** specified the quote labor units on service recommendation flow ([#1440](https://github.com/provusinc/quoting/issues/1440)) ([48ee5e4](https://github.com/provusinc/quoting/commit/48ee5e46f2477f523bdd0ffd220e45d45032f486))
* **psq-5684:** incorrect number of recurring hours added ([#1438](https://github.com/provusinc/quoting/issues/1438)) ([ec0c85d](https://github.com/provusinc/quoting/commit/ec0c85df40268620ded6cfebc2213f44b6d23f6a))
* **psq-5698:** readonly std rate and std cost ([#1444](https://github.com/provusinc/quoting/issues/1444)) ([abf0fc1](https://github.com/provusinc/quoting/commit/abf0fc1e81342ddb347bbeb6e984c98fe17fd5a8))
* **psq-5703:** changes to delete named ranges when deleting quote period/groups records ([#1453](https://github.com/provusinc/quoting/issues/1453)) ([91c9343](https://github.com/provusinc/quoting/commit/91c93438e664d3e7e511b7149b81246742bdb8e8))
* **psq-5704:** incorrect end date calculated, splits should not use min ([#1445](https://github.com/provusinc/quoting/issues/1445)) ([e999d57](https://github.com/provusinc/quoting/commit/e999d57580ee6695373c7e59e7259bd3cabbb81e))
* **psq-5709:** Detect if there is an error in the hyperformula and show a toast message (followup) ([#1458](https://github.com/provusinc/quoting/issues/1458)) ([7438aab](https://github.com/provusinc/quoting/commit/7438aab4dd87472786b05e295fb98b4f6c07715f))
* **psq-5737:** includes decimals for side to side comparison ([#1449](https://github.com/provusinc/quoting/issues/1449)) ([b6b7356](https://github.com/provusinc/quoting/commit/b6b7356ea066211921ba5da79e48af6f36fa13a9))
* **psq-5738:** populate quote name as default in template name ([#1456](https://github.com/provusinc/quoting/issues/1456)) ([e1bc198](https://github.com/provusinc/quoting/commit/e1bc19865c90f8e29cc7d94c4db73c3fb99471e5))
* **psq-5748:** collaboration quote import resources menu iem should be hidden ([#1448](https://github.com/provusinc/quoting/issues/1448)) ([2f51f4b](https://github.com/provusinc/quoting/commit/2f51f4b659eee7d1597f3990fd22950a78b3b5b2))
* **psq-5752:** task role summaries deleted due to dto update ([#1455](https://github.com/provusinc/quoting/issues/1455)) ([dc9e0d4](https://github.com/provusinc/quoting/commit/dc9e0d4b6a95b4630074983a958e86d0bda2075a))
* **psq-5764:** select correct rate card item ([#1479](https://github.com/provusinc/quoting/issues/1479)) ([4ff9614](https://github.com/provusinc/quoting/commit/4ff96141c2b89db2550ca2fdbe02baa5e666c750))
* **psq-5765, psq-5766, psq-5767:** allow test hashtag to be valid ([#1467](https://github.com/provusinc/quoting/issues/1467)) ([ad52b72](https://github.com/provusinc/quoting/commit/ad52b728d7949972b140f62848e6a2099706df81))
* **psq-5765:** addressed cases where we update an existing scope parameter ([#1471](https://github.com/provusinc/quoting/issues/1471)) ([52ca539](https://github.com/provusinc/quoting/commit/52ca53931058b7ab2ca359b56b7901eae9a5099c))
* **psq-5765:** update hashtag name with new scope parameter name ([#1474](https://github.com/provusinc/quoting/issues/1474)) ([00c2058](https://github.com/provusinc/quoting/commit/00c205858004fb1cee7d0e29427988f319896fcf))
* **psq-5773:** show non-adjusted revenue ([#1487](https://github.com/provusinc/quoting/issues/1487)) ([a22b673](https://github.com/provusinc/quoting/commit/a22b6732cba670d37db01e5f42f22998e108b20d))
* **psq-5819:** round displayed discount amount ([#1486](https://github.com/provusinc/quoting/issues/1486)) ([c59f419](https://github.com/provusinc/quoting/commit/c59f419d4f09e14996de47cc1b11054cc1c3f081))
* **psq-5820:** fixed loading formulas in estimate tab for quote ([#1488](https://github.com/provusinc/quoting/issues/1488)) ([922e68b](https://github.com/provusinc/quoting/commit/922e68b61ec381014972ac63b39a9486847e4f6d))
* **psq-5823:** estimate template manager able to copy and paste to another template ([#1490](https://github.com/provusinc/quoting/issues/1490)) ([035a26a](https://github.com/provusinc/quoting/commit/035a26ad16c3f1d7b879b5f95e8fd66d13fcd1d9))
* **psq-5829:** enable Run Flows in quote manager permission set ([#1506](https://github.com/provusinc/quoting/issues/1506)) ([3c9c5fb](https://github.com/provusinc/quoting/commit/3c9c5fb13c608a86e1e151f377312104d4043be7))
* **psq-5829:** enabled flows for quote managers ([#1493](https://github.com/provusinc/quoting/issues/1493)) ([3151d4b](https://github.com/provusinc/quoting/commit/3151d4bde40b91ea61089f6f8d4b36a12ce1fb43))
* **psq-5829:** revert permission set changes ([#1505](https://github.com/provusinc/quoting/issues/1505)) ([d5f86bc](https://github.com/provusinc/quoting/commit/d5f86bcec0a2f6d1636a48bada8b95641bb42c43))
* **psq-5832:** user should be able to see estimate details ([#1491](https://github.com/provusinc/quoting/issues/1491)) ([dc80fc7](https://github.com/provusinc/quoting/commit/dc80fc7107c4a96af77f4c56241da655263d141a))
* **psq-5835:** populate section display sequence on estimate delta sync ([#1495](https://github.com/provusinc/quoting/issues/1495)) ([9a393e8](https://github.com/provusinc/quoting/commit/9a393e850acdbfcf2a6ec2bbf1c3618da8760576))
* **psq-5835:** quote sections always sequenced to 1 ([#1500](https://github.com/provusinc/quoting/issues/1500)) ([e9c8fed](https://github.com/provusinc/quoting/commit/e9c8fed0e0205c0d8f0c64d229cf82eda054e7e2))
* **psq-5838:** resource availability not applied in sync to quote ([#1501](https://github.com/provusinc/quoting/issues/1501)) ([e094362](https://github.com/provusinc/quoting/commit/e0943623cfc801cf44c79e8b925a30745a9fa620))
* quote flexi page duplicates labor units dropdown ([b81438d](https://github.com/provusinc/quoting/commit/b81438d8492d5cabb7a16f12070c831349c2cda7))
* quote flexi page duplicates labor units dropdown ([313745c](https://github.com/provusinc/quoting/commit/313745c9d67532ab162ca03a702ec05674ef74fa))
* **quote grid:** avoid grid rerender which causes flashing ([#1419](https://github.com/provusinc/quoting/issues/1419)) ([aff21be](https://github.com/provusinc/quoting/commit/aff21be677acb513d93b1ce731f7974f6da8ec96))
* remove currency iso code from layout ([afdf34c](https://github.com/provusinc/quoting/commit/afdf34c5a8c77bf4c48df3a908e7a6dd73435812))
* the end date calculation is incorrect when there are a mix of split and non-split ([#1457](https://github.com/provusinc/quoting/issues/1457)) ([15bacdf](https://github.com/provusinc/quoting/commit/15bacdf72a56ec979031030acc557073a285c5dc))
* trigger build ([fd522d4](https://github.com/provusinc/quoting/commit/fd522d4a6ac925508418300ac01589bbacc7885f))

## [2.38.0-next.19](https://github.com/provusinc/quoting/compare/v2.38.0-next.18...v2.38.0-next.19) (2022-09-13)


### Bug Fixes

* quote flexi page duplicates labor units dropdown ([b81438d](https://github.com/provusinc/quoting/commit/b81438d8492d5cabb7a16f12070c831349c2cda7))
* quote flexi page duplicates labor units dropdown ([313745c](https://github.com/provusinc/quoting/commit/313745c9d67532ab162ca03a702ec05674ef74fa))

## [2.38.0-next.18](https://github.com/provusinc/quoting/compare/v2.38.0-next.17...v2.38.0-next.18) (2022-09-12)


### Bug Fixes

* exclude addon item in delta sync estimate to quote flow ([#1507](https://github.com/provusinc/quoting/issues/1507)) ([96fecbf](https://github.com/provusinc/quoting/commit/96fecbf25005815c784af3fd9c8ad00f84bdfaca))

## [2.38.0-next.17](https://github.com/provusinc/quoting/compare/v2.38.0-next.16...v2.38.0-next.17) (2022-09-09)


### Bug Fixes

* **psq-5829:** enable Run Flows in quote manager permission set ([#1506](https://github.com/provusinc/quoting/issues/1506)) ([3c9c5fb](https://github.com/provusinc/quoting/commit/3c9c5fb13c608a86e1e151f377312104d4043be7))

## [2.38.0-next.16](https://github.com/provusinc/quoting/compare/v2.38.0-next.15...v2.38.0-next.16) (2022-09-09)


### Bug Fixes

* **psq-5829:** revert permission set changes ([#1505](https://github.com/provusinc/quoting/issues/1505)) ([d5f86bc](https://github.com/provusinc/quoting/commit/d5f86bcec0a2f6d1636a48bada8b95641bb42c43))

## [2.38.0-next.15](https://github.com/provusinc/quoting/compare/v2.38.0-next.14...v2.38.0-next.15) (2022-09-09)


### Features

* **psq-5825:** clone resource availability records when estimate cloned ([#1492](https://github.com/provusinc/quoting/issues/1492)) ([d0846ed](https://github.com/provusinc/quoting/commit/d0846ed9bdb1c2bfbba747e01fa262fd6bcda02b))


### Bug Fixes

* **psq-5838:** resource availability not applied in sync to quote ([#1501](https://github.com/provusinc/quoting/issues/1501)) ([e094362](https://github.com/provusinc/quoting/commit/e0943623cfc801cf44c79e8b925a30745a9fa620))
* remove currency iso code from layout ([afdf34c](https://github.com/provusinc/quoting/commit/afdf34c5a8c77bf4c48df3a908e7a6dd73435812))

## [2.38.0-next.14](https://github.com/provusinc/quoting/compare/v2.38.0-next.13...v2.38.0-next.14) (2022-09-08)


### Bug Fixes

* **psq-5835:** quote sections always sequenced to 1 ([#1500](https://github.com/provusinc/quoting/issues/1500)) ([e9c8fed](https://github.com/provusinc/quoting/commit/e9c8fed0e0205c0d8f0c64d229cf82eda054e7e2))

## [2.38.0-next.13](https://github.com/provusinc/quoting/compare/v2.38.0-next.12...v2.38.0-next.13) (2022-09-08)


### Features

* **psq-5845:** show sync to quote if the quote id exists ([#1499](https://github.com/provusinc/quoting/issues/1499)) ([0a30053](https://github.com/provusinc/quoting/commit/0a30053907bb2915a1d996164b6915e5c65320a7))


### Bug Fixes

* permissions for LocationDiscountController and ImportDatatableController are missing ([#1477](https://github.com/provusinc/quoting/issues/1477)) ([d12e0ef](https://github.com/provusinc/quoting/commit/d12e0efb1da0c26b8399d4b871b4a579a193572e))
* **psq-5819:** round displayed discount amount ([#1486](https://github.com/provusinc/quoting/issues/1486)) ([c59f419](https://github.com/provusinc/quoting/commit/c59f419d4f09e14996de47cc1b11054cc1c3f081))
* **resetting-of-key:** retrieving of package namespace should not be timing dependent ([#1497](https://github.com/provusinc/quoting/issues/1497)) ([85b95aa](https://github.com/provusinc/quoting/commit/85b95aa4aa70cfad4fbdb6ed1fd1b34051d74f30)), closes [#1494](https://github.com/provusinc/quoting/issues/1494)
* **schema data service:** wire in namespace rather than using component ([#1494](https://github.com/provusinc/quoting/issues/1494)) ([e6c3b75](https://github.com/provusinc/quoting/commit/e6c3b75606fa029c60367c24668e923b44e1218e))

## [2.38.0-next.12](https://github.com/provusinc/quoting/compare/v2.38.0-next.11...v2.38.0-next.12) (2022-09-07)


### Features

* **psq-5724:** unit test sobject cloner ([#1496](https://github.com/provusinc/quoting/issues/1496)) ([d3cc0f6](https://github.com/provusinc/quoting/commit/d3cc0f6997fe9a716d6ffa123d225ef5be0a3728))

## [2.38.0-next.11](https://github.com/provusinc/quoting/compare/v2.38.0-next.10...v2.38.0-next.11) (2022-09-07)


### Bug Fixes

* **psq-5835:** populate section display sequence on estimate delta sync ([#1495](https://github.com/provusinc/quoting/issues/1495)) ([9a393e8](https://github.com/provusinc/quoting/commit/9a393e850acdbfcf2a6ec2bbf1c3618da8760576))

## [2.38.0-next.10](https://github.com/provusinc/quoting/compare/v2.38.0-next.9...v2.38.0-next.10) (2022-09-07)


### Bug Fixes

* **psq-5829:** enabled flows for quote managers ([#1493](https://github.com/provusinc/quoting/issues/1493)) ([3151d4b](https://github.com/provusinc/quoting/commit/3151d4bde40b91ea61089f6f8d4b36a12ce1fb43))

## [2.38.0-next.9](https://github.com/provusinc/quoting/compare/v2.38.0-next.8...v2.38.0-next.9) (2022-09-07)


### Features

* **psq-5722:** implement cloning service ([#1480](https://github.com/provusinc/quoting/issues/1480)) ([e4bc827](https://github.com/provusinc/quoting/commit/e4bc8271b088735d8edd3dcd6ae055977d37eb1f))
* **psq-5753:** updated saveTotals to support new pricing beta for adjustments ([#1483](https://github.com/provusinc/quoting/issues/1483)) ([b34b028](https://github.com/provusinc/quoting/commit/b34b028f193e214afc53e364955970b9674db5d2))
* **psq-5801:** create quote schema data ([#1481](https://github.com/provusinc/quoting/issues/1481)) ([ab7ebd7](https://github.com/provusinc/quoting/commit/ab7ebd72dacb8a45ce5778c2e1c53de25b4f298b))


### Bug Fixes

* **psq-5823:** estimate template manager able to copy and paste to another template ([#1490](https://github.com/provusinc/quoting/issues/1490)) ([035a26a](https://github.com/provusinc/quoting/commit/035a26ad16c3f1d7b879b5f95e8fd66d13fcd1d9))
* **psq-5832:** user should be able to see estimate details ([#1491](https://github.com/provusinc/quoting/issues/1491)) ([dc80fc7](https://github.com/provusinc/quoting/commit/dc80fc7107c4a96af77f4c56241da655263d141a))

## [2.38.0-next.8](https://github.com/provusinc/quoting/compare/v2.38.0-next.7...v2.38.0-next.8) (2022-09-06)


### Bug Fixes

* **psq-5820:** fixed loading formulas in estimate tab for quote ([#1488](https://github.com/provusinc/quoting/issues/1488)) ([922e68b](https://github.com/provusinc/quoting/commit/922e68b61ec381014972ac63b39a9486847e4f6d))

## [2.38.0-next.7](https://github.com/provusinc/quoting/compare/v2.38.0-next.6...v2.38.0-next.7) (2022-09-06)


### Features

* **psq-5826:** non-billable item period group should show zero ([#1489](https://github.com/provusinc/quoting/issues/1489)) ([2c517a3](https://github.com/provusinc/quoting/commit/2c517a3c2835527accd37b316075adcf69cd70a7))


### Bug Fixes

* **psq-5703:** changes to delete named ranges when deleting quote period/groups records ([#1453](https://github.com/provusinc/quoting/issues/1453)) ([91c9343](https://github.com/provusinc/quoting/commit/91c93438e664d3e7e511b7149b81246742bdb8e8))

## [2.38.0-next.6](https://github.com/provusinc/quoting/compare/v2.38.0-next.5...v2.38.0-next.6) (2022-09-03)


### Features

* **psq-5805:** when no total by value selected should not save volume discount ([#1484](https://github.com/provusinc/quoting/issues/1484)) ([55b029c](https://github.com/provusinc/quoting/commit/55b029cd604199ae89df4b5e395b735f2d22011e))


### Bug Fixes

* **psq-5773:** show non-adjusted revenue ([#1487](https://github.com/provusinc/quoting/issues/1487)) ([a22b673](https://github.com/provusinc/quoting/commit/a22b6732cba670d37db01e5f42f22998e108b20d))

## [2.38.0-next.5](https://github.com/provusinc/quoting/compare/v2.38.0-next.4...v2.38.0-next.5) (2022-09-02)


### Features

* **psq-5717:** ui should only display and save one volume discount at a time ([#1482](https://github.com/provusinc/quoting/issues/1482)) ([a9aa12e](https://github.com/provusinc/quoting/commit/a9aa12e812355bcbd15fad2c18b05da2f0858eed))


### Bug Fixes

* **psq-5764:** select correct rate card item ([#1479](https://github.com/provusinc/quoting/issues/1479)) ([4ff9614](https://github.com/provusinc/quoting/commit/4ff96141c2b89db2550ca2fdbe02baa5e666c750))

## [2.38.0-next.4](https://github.com/provusinc/quoting/compare/v2.38.0-next.3...v2.38.0-next.4) (2022-09-01)


### Features

* **pspq-5727:** add data model and layouts for clone settings ([#1472](https://github.com/provusinc/quoting/issues/1472)) ([1e6ecb6](https://github.com/provusinc/quoting/commit/1e6ecb6d8746f67b118e6949c59bef845c654cce))
* **psq-5718:** added support to delete volume discounts ([#1476](https://github.com/provusinc/quoting/issues/1476)) ([9e20de5](https://github.com/provusinc/quoting/commit/9e20de54bc2b02d1dcf94f83121df66ed3a50b2f))
* **psq-5723:** implement preprocessor to return referenced object names ([#1475](https://github.com/provusinc/quoting/issues/1475)) ([b489b66](https://github.com/provusinc/quoting/commit/b489b6684b20544400820e17a1586e53f7421bbe))
* **psq-5726:** feature flag for clone scenario ([#1465](https://github.com/provusinc/quoting/issues/1465)) ([dcf716b](https://github.com/provusinc/quoting/commit/dcf716ba466a947c2dff19b7ce70e83770a7946d))
* **psq-5782:** introduced feature flag around new pricing changes ([#1470](https://github.com/provusinc/quoting/issues/1470)) ([beef34e](https://github.com/provusinc/quoting/commit/beef34e9db3ce50ecc41602b4d0183b4af8d5df4))


### Bug Fixes

* **psq-5765:** update hashtag name with new scope parameter name ([#1474](https://github.com/provusinc/quoting/issues/1474)) ([00c2058](https://github.com/provusinc/quoting/commit/00c205858004fb1cee7d0e29427988f319896fcf))

## [2.38.0-next.3](https://github.com/provusinc/quoting/compare/v2.38.0-next.2...v2.38.0-next.3) (2022-08-31)


### Features

* **custom labels:** fix dupe custom labels ([55199ff](https://github.com/provusinc/quoting/commit/55199ff5f7293ce80c92a97779491878b4aaef63))
* **psq-5518:** estimator rewrite scope summary ([#1439](https://github.com/provusinc/quoting/issues/1439)) ([ce09220](https://github.com/provusinc/quoting/commit/ce092207f8ea6ff2ec3dbc14d09de25b156a5bcc))
* **psq-5685:** estimator rewrite not applicable toggle ([#1447](https://github.com/provusinc/quoting/issues/1447)) ([b8ef809](https://github.com/provusinc/quoting/commit/b8ef8094d3e48bbf2c4881e86a2de1adf10a2152))
* **psq-5792:** enforce hashtag pattern in scope parameter dialog ([#1469](https://github.com/provusinc/quoting/issues/1469)) ([25f6e3d](https://github.com/provusinc/quoting/commit/25f6e3d177163f7521ac9419c4542a7d26f83de0))


### Bug Fixes

* **psq-5765:** addressed cases where we update an existing scope parameter ([#1471](https://github.com/provusinc/quoting/issues/1471)) ([52ca539](https://github.com/provusinc/quoting/commit/52ca53931058b7ab2ca359b56b7901eae9a5099c))

## [2.38.0-next.2](https://github.com/provusinc/quoting/compare/v2.38.0-next.1...v2.38.0-next.2) (2022-08-30)


### Features

* **psq-5721:** data model and page layouts for clone schema definition ([#1468](https://github.com/provusinc/quoting/issues/1468)) ([22ba313](https://github.com/provusinc/quoting/commit/22ba31307314eeae3b3a66ec4251b69a79c8e1dc))


### Bug Fixes

* **psq-5738:** populate quote name as default in template name ([#1456](https://github.com/provusinc/quoting/issues/1456)) ([e1bc198](https://github.com/provusinc/quoting/commit/e1bc19865c90f8e29cc7d94c4db73c3fb99471e5))
* **psq-5765, psq-5766, psq-5767:** allow test hashtag to be valid ([#1467](https://github.com/provusinc/quoting/issues/1467)) ([ad52b72](https://github.com/provusinc/quoting/commit/ad52b728d7949972b140f62848e6a2099706df81))

## [2.38.0-next.1](https://github.com/provusinc/quoting/compare/v2.37.0...v2.38.0-next.1) (2022-08-29)


### Features

* **estimator:** initial rewrite ([71f7a2f](https://github.com/provusinc/quoting/commit/71f7a2f3ec208ae376e51490e604db9dcdb7710d))
* **estimator:** initial rewrite ([4419c44](https://github.com/provusinc/quoting/commit/4419c443871ad0cf3ac77466e820ff84d98eb27f))
* **psq-4813:** added unittest and removed generation code ([760260a](https://github.com/provusinc/quoting/commit/760260a8c4d839a7de5d3dfb3deacb1ecdeaec38))
* **psq-4813:** updated test to account for quote id ([a1f8b95](https://github.com/provusinc/quoting/commit/a1f8b951bb46b0ae97db6d85f2bf4c67832fc27a))
* **psq-4947:** disable proposal sync when disable automatic opp sync ([#1451](https://github.com/provusinc/quoting/issues/1451)) ([611f2ba](https://github.com/provusinc/quoting/commit/611f2badfa314c8dd3d1f50a19e746a8f8679616))
* **psq-5522:** conditional show estimate level buttons in new estimator ([#1450](https://github.com/provusinc/quoting/issues/1450)) ([8f3ab4b](https://github.com/provusinc/quoting/commit/8f3ab4b6889055e8aa73e01bd1668fafcb4caafe))
* **psq-5563:** created lwc for save as template dialog ([#1425](https://github.com/provusinc/quoting/issues/1425)) ([e281e18](https://github.com/provusinc/quoting/commit/e281e180eef4da08910752f998223dfd693e4771))
* **psq-5621:** handle calculated duration in new estimator ([#1433](https://github.com/provusinc/quoting/issues/1433)) ([1c27fec](https://github.com/provusinc/quoting/commit/1c27fec8a098285e2498912d611aadcc124b2441))
* **psq-5682:** populated quote total amount from estimate total amount ([#1446](https://github.com/provusinc/quoting/issues/1446)) ([30382de](https://github.com/provusinc/quoting/commit/30382de0a000609df0e618f0eeb52541c01efc9d)), closes [#1425](https://github.com/provusinc/quoting/issues/1425)
* **psq-5709:** validation for improperly formatted formulae ([#1454](https://github.com/provusinc/quoting/issues/1454)) ([71e2c6a](https://github.com/provusinc/quoting/commit/71e2c6a118708e3ea81aae5f7e0ae20f779b6708))
* **psq-5711:** Update the hashtag service if a scope parameter is added or removed ([#1463](https://github.com/provusinc/quoting/issues/1463)) ([ec9883c](https://github.com/provusinc/quoting/commit/ec9883cc0b5d596fc312b0e054d7ba166fba2245))
* **psq-5714, psq-5712, psq-5710:** validate params against dictionary ([#1460](https://github.com/provusinc/quoting/issues/1460)) ([5c7e471](https://github.com/provusinc/quoting/commit/5c7e4711ec892a7ff848eb0b58f71370bb3aa674))


### Bug Fixes

* **psq-5416:** incorrect end date calculated in estimate ([#1436](https://github.com/provusinc/quoting/issues/1436)) ([5d9431a](https://github.com/provusinc/quoting/commit/5d9431a336249e1fe1be63ebc58a77a4c48ddc09))
* **psq-5609:** fix how formula evaluator looks at tokens ([60af566](https://github.com/provusinc/quoting/commit/60af566279ac825a0850ea45bfcda7ae4cd01a77))
* **psq-5631:** contingencies dialog should close when save button clicked ([#1452](https://github.com/provusinc/quoting/issues/1452)) ([8820dd9](https://github.com/provusinc/quoting/commit/8820dd9031da06899b2a0bd8e045b826d02bddea))
* **psq-5640:** task parameter values werent getting copied over ([71274bd](https://github.com/provusinc/quoting/commit/71274bd56ee99ff7a23562f198e3a02272532e06))
* **psq-5669:** fix when decimal falls between tiers ([#1435](https://github.com/provusinc/quoting/issues/1435)) ([2e855e5](https://github.com/provusinc/quoting/commit/2e855e5ddd6c1186c1fc28ca484b363d52f5b56b))
* **psq-5680:** cap period generation to max quote item cell periods ([#1434](https://github.com/provusinc/quoting/issues/1434)) ([972f263](https://github.com/provusinc/quoting/commit/972f26356e58964047df81009bbdb240420e0b82))
* **psq-5681:** specified the quote labor units on service recommendation flow ([#1440](https://github.com/provusinc/quoting/issues/1440)) ([48ee5e4](https://github.com/provusinc/quoting/commit/48ee5e46f2477f523bdd0ffd220e45d45032f486))
* **psq-5684:** incorrect number of recurring hours added ([#1438](https://github.com/provusinc/quoting/issues/1438)) ([ec0c85d](https://github.com/provusinc/quoting/commit/ec0c85df40268620ded6cfebc2213f44b6d23f6a))
* **psq-5698:** readonly std rate and std cost ([#1444](https://github.com/provusinc/quoting/issues/1444)) ([abf0fc1](https://github.com/provusinc/quoting/commit/abf0fc1e81342ddb347bbeb6e984c98fe17fd5a8))
* **psq-5704:** incorrect end date calculated, splits should not use min ([#1445](https://github.com/provusinc/quoting/issues/1445)) ([e999d57](https://github.com/provusinc/quoting/commit/e999d57580ee6695373c7e59e7259bd3cabbb81e))
* **psq-5709:** Detect if there is an error in the hyperformula and show a toast message (followup) ([#1458](https://github.com/provusinc/quoting/issues/1458)) ([7438aab](https://github.com/provusinc/quoting/commit/7438aab4dd87472786b05e295fb98b4f6c07715f))
* **psq-5737:** includes decimals for side to side comparison ([#1449](https://github.com/provusinc/quoting/issues/1449)) ([b6b7356](https://github.com/provusinc/quoting/commit/b6b7356ea066211921ba5da79e48af6f36fa13a9))
* **psq-5748:** collaboration quote import resources menu iem should be hidden ([#1448](https://github.com/provusinc/quoting/issues/1448)) ([2f51f4b](https://github.com/provusinc/quoting/commit/2f51f4b659eee7d1597f3990fd22950a78b3b5b2))
* **psq-5752:** task role summaries deleted due to dto update ([#1455](https://github.com/provusinc/quoting/issues/1455)) ([dc9e0d4](https://github.com/provusinc/quoting/commit/dc9e0d4b6a95b4630074983a958e86d0bda2075a))
* **quote grid:** avoid grid rerender which causes flashing ([#1419](https://github.com/provusinc/quoting/issues/1419)) ([aff21be](https://github.com/provusinc/quoting/commit/aff21be677acb513d93b1ce731f7974f6da8ec96))
* the end date calculation is incorrect when there are a mix of split and non-split ([#1457](https://github.com/provusinc/quoting/issues/1457)) ([15bacdf](https://github.com/provusinc/quoting/commit/15bacdf72a56ec979031030acc557073a285c5dc))
* trigger build ([fd522d4](https://github.com/provusinc/quoting/commit/fd522d4a6ac925508418300ac01589bbacc7885f))

## [2.37.0-next.73](https://github.com/provusinc/quoting/compare/v2.37.0-next.72...v2.37.0-next.73) (2022-08-26)


### Bug Fixes

* the end date calculation is incorrect when there are a mix of split and non-split ([#1457](https://github.com/provusinc/quoting/issues/1457)) ([15bacdf](https://github.com/provusinc/quoting/commit/15bacdf72a56ec979031030acc557073a285c5dc))

## [2.37.0-next.72](https://github.com/provusinc/quoting/compare/v2.37.0-next.71...v2.37.0-next.72) (2022-08-26)


### Bug Fixes

* **psq-5709:** Detect if there is an error in the hyperformula and show a toast message (followup) ([#1458](https://github.com/provusinc/quoting/issues/1458)) ([7438aab](https://github.com/provusinc/quoting/commit/7438aab4dd87472786b05e295fb98b4f6c07715f))

## [2.37.0-next.71](https://github.com/provusinc/quoting/compare/v2.37.0-next.70...v2.37.0-next.71) (2022-08-25)


### Features

* **psq-5709:** validation for improperly formatted formulae ([#1454](https://github.com/provusinc/quoting/issues/1454)) ([71e2c6a](https://github.com/provusinc/quoting/commit/71e2c6a118708e3ea81aae5f7e0ae20f779b6708))


### Bug Fixes

* **psq-5752:** task role summaries deleted due to dto update ([#1455](https://github.com/provusinc/quoting/issues/1455)) ([dc9e0d4](https://github.com/provusinc/quoting/commit/dc9e0d4b6a95b4630074983a958e86d0bda2075a))

## [2.37.0-next.70](https://github.com/provusinc/quoting/compare/v2.37.0-next.69...v2.37.0-next.70) (2022-08-25)


### Features

* **psq-4947:** disable proposal sync when disable automatic opp sync ([#1451](https://github.com/provusinc/quoting/issues/1451)) ([611f2ba](https://github.com/provusinc/quoting/commit/611f2badfa314c8dd3d1f50a19e746a8f8679616))
* **psq-5522:** conditional show estimate level buttons in new estimator ([#1450](https://github.com/provusinc/quoting/issues/1450)) ([8f3ab4b](https://github.com/provusinc/quoting/commit/8f3ab4b6889055e8aa73e01bd1668fafcb4caafe))
* **psq-5682:** populated quote total amount from estimate total amount ([#1446](https://github.com/provusinc/quoting/issues/1446)) ([30382de](https://github.com/provusinc/quoting/commit/30382de0a000609df0e618f0eeb52541c01efc9d)), closes [#1425](https://github.com/provusinc/quoting/issues/1425)


### Bug Fixes

* **psq-5631:** contingencies dialog should close when save button clicked ([#1452](https://github.com/provusinc/quoting/issues/1452)) ([8820dd9](https://github.com/provusinc/quoting/commit/8820dd9031da06899b2a0bd8e045b826d02bddea))
* **psq-5698:** readonly std rate and std cost ([#1444](https://github.com/provusinc/quoting/issues/1444)) ([abf0fc1](https://github.com/provusinc/quoting/commit/abf0fc1e81342ddb347bbeb6e984c98fe17fd5a8))
* **psq-5704:** incorrect end date calculated, splits should not use min ([#1445](https://github.com/provusinc/quoting/issues/1445)) ([e999d57](https://github.com/provusinc/quoting/commit/e999d57580ee6695373c7e59e7259bd3cabbb81e))
* **psq-5737:** includes decimals for side to side comparison ([#1449](https://github.com/provusinc/quoting/issues/1449)) ([b6b7356](https://github.com/provusinc/quoting/commit/b6b7356ea066211921ba5da79e48af6f36fa13a9))
* **psq-5748:** collaboration quote import resources menu iem should be hidden ([#1448](https://github.com/provusinc/quoting/issues/1448)) ([2f51f4b](https://github.com/provusinc/quoting/commit/2f51f4b659eee7d1597f3990fd22950a78b3b5b2))

## [2.37.0-next.69](https://github.com/provusinc/quoting/compare/v2.37.0-next.68...v2.37.0-next.69) (2022-08-23)


### Features

* **psq-5621:** handle calculated duration in new estimator ([#1433](https://github.com/provusinc/quoting/issues/1433)) ([1c27fec](https://github.com/provusinc/quoting/commit/1c27fec8a098285e2498912d611aadcc124b2441))

## [2.37.0-next.68](https://github.com/provusinc/quoting/compare/v2.37.0-next.67...v2.37.0-next.68) (2022-08-23)


### Features

* **psq-5563:** created lwc for save as template dialog ([#1425](https://github.com/provusinc/quoting/issues/1425)) ([e281e18](https://github.com/provusinc/quoting/commit/e281e180eef4da08910752f998223dfd693e4771))


### Bug Fixes

* **psq-5681:** specified the quote labor units on service recommendation flow ([#1440](https://github.com/provusinc/quoting/issues/1440)) ([48ee5e4](https://github.com/provusinc/quoting/commit/48ee5e46f2477f523bdd0ffd220e45d45032f486))

## [2.37.0-next.67](https://github.com/provusinc/quoting/compare/v2.37.0-next.66...v2.37.0-next.67) (2022-08-23)


### Bug Fixes

* **psq-5416:** incorrect end date calculated in estimate ([#1436](https://github.com/provusinc/quoting/issues/1436)) ([5d9431a](https://github.com/provusinc/quoting/commit/5d9431a336249e1fe1be63ebc58a77a4c48ddc09))
* **psq-5680:** cap period generation to max quote item cell periods ([#1434](https://github.com/provusinc/quoting/issues/1434)) ([972f263](https://github.com/provusinc/quoting/commit/972f26356e58964047df81009bbdb240420e0b82))
* **psq-5684:** incorrect number of recurring hours added ([#1438](https://github.com/provusinc/quoting/issues/1438)) ([ec0c85d](https://github.com/provusinc/quoting/commit/ec0c85df40268620ded6cfebc2213f44b6d23f6a))

## [2.37.0-next.66](https://github.com/provusinc/quoting/compare/v2.37.0-next.65...v2.37.0-next.66) (2022-08-22)


### Bug Fixes

* **psq-5669:** fix when decimal falls between tiers ([#1435](https://github.com/provusinc/quoting/issues/1435)) ([2e855e5](https://github.com/provusinc/quoting/commit/2e855e5ddd6c1186c1fc28ca484b363d52f5b56b))

## [2.37.0-next.65](https://github.com/provusinc/quoting/compare/v2.37.0-next.64...v2.37.0-next.65) (2022-08-20)


### Bug Fixes

* **psq-5640:** task parameter values werent getting copied over ([71274bd](https://github.com/provusinc/quoting/commit/71274bd56ee99ff7a23562f198e3a02272532e06))
* trigger build ([fd522d4](https://github.com/provusinc/quoting/commit/fd522d4a6ac925508418300ac01589bbacc7885f))

## [2.37.0-next.64](https://github.com/provusinc/quoting/compare/v2.37.0-next.63...v2.37.0-next.64) (2022-08-19)


### Features

* **estimator:** initial rewrite ([71f7a2f](https://github.com/provusinc/quoting/commit/71f7a2f3ec208ae376e51490e604db9dcdb7710d))
* **estimator:** initial rewrite ([4419c44](https://github.com/provusinc/quoting/commit/4419c443871ad0cf3ac77466e820ff84d98eb27f))
* **psq-4813:** added unittest and removed generation code ([760260a](https://github.com/provusinc/quoting/commit/760260a8c4d839a7de5d3dfb3deacb1ecdeaec38))
* **psq-4813:** updated test to account for quote id ([a1f8b95](https://github.com/provusinc/quoting/commit/a1f8b951bb46b0ae97db6d85f2bf4c67832fc27a))

## [2.37.0-next.63](https://github.com/provusinc/quoting/compare/v2.37.0-next.62...v2.37.0-next.63) (2022-08-18)


### Bug Fixes

* **psq-5609:** fix how formula evaluator looks at tokens ([60af566](https://github.com/provusinc/quoting/commit/60af566279ac825a0850ea45bfcda7ae4cd01a77))

## [2.37.0-next.62](https://github.com/provusinc/quoting/compare/v2.37.0-next.61...v2.37.0-next.62) (2022-08-18)


### Bug Fixes

* **psq-4903:** skip creation of totals records when creating a derived from quote ([df2ba3b](https://github.com/provusinc/quoting/commit/df2ba3bf076f8450103980c6d0d0b0e66d1c815b))
* **psq-4913:** clear draft values for selected indices ([#1281](https://github.com/provusinc/quoting/issues/1281)) ([e0a6e57](https://github.com/provusinc/quoting/commit/e0a6e57b0e9c820e7f74e8c5719b71025e4f94c7))
* **psq-4939:** nonbillable item populate grandtotal ([#1287](https://github.com/provusinc/quoting/issues/1287)) ([3e2abaf](https://github.com/provusinc/quoting/commit/3e2abafe319c9df9d2b0b33370450e29ee5f59fe))
* **psq-4946:** changes to add correct service through show service Recommendations ([#1274](https://github.com/provusinc/quoting/issues/1274)) ([#1282](https://github.com/provusinc/quoting/issues/1282)) ([ec40a2c](https://github.com/provusinc/quoting/commit/ec40a2c29580ff7f493ebaf4ef03bc99c2f4b0dd))
* **quote grid:** avoid grid rerender which causes flashing ([#1419](https://github.com/provusinc/quoting/issues/1419)) ([aff21be](https://github.com/provusinc/quoting/commit/aff21be677acb513d93b1ce731f7974f6da8ec96))

## [2.37.0-next.61](https://github.com/provusinc/quoting/compare/v2.37.0-next.60...v2.37.0-next.61) (2022-08-17)


### Bug Fixes

* **quote grid:** row move fix ([#1418](https://github.com/provusinc/quoting/issues/1418)) ([314dc94](https://github.com/provusinc/quoting/commit/314dc943ffe4f8bc17121cbfd2bab1d53def3232))

## [2.37.0-next.60](https://github.com/provusinc/quoting/compare/v2.37.0-next.59...v2.37.0-next.60) (2022-08-17)


### Bug Fixes

* **psq-5539:** save user selected value as it is ([#1417](https://github.com/provusinc/quoting/issues/1417)) ([ae0f3e0](https://github.com/provusinc/quoting/commit/ae0f3e014ae4e7e5995cef59164b7149fdc66451))

## [2.37.0-next.59](https://github.com/provusinc/quoting/compare/v2.37.0-next.58...v2.37.0-next.59) (2022-08-17)


### Features

* **psq-5566:** change contingencies tab label to reflect the correct name ([#1416](https://github.com/provusinc/quoting/issues/1416)) ([41b019b](https://github.com/provusinc/quoting/commit/41b019b92e607fcdd606fcdd15a5c48c0451d854))


### Bug Fixes

* **psq-5494:** row is inserted in the wrong location ([9fb1ea4](https://github.com/provusinc/quoting/commit/9fb1ea40ca8110f6e24b541bc2c856302bb19ccf))

## [2.37.0-next.58](https://github.com/provusinc/quoting/compare/v2.37.0-next.57...v2.37.0-next.58) (2022-08-17)


### Features

* trigger build ([63ec43e](https://github.com/provusinc/quoting/commit/63ec43e2b57f380dd2bf0cf2affca0212370ee1a))

## [2.37.0-next.57](https://github.com/provusinc/quoting/compare/v2.37.0-next.56...v2.37.0-next.57) (2022-08-17)


### Bug Fixes

* **psq-5484:** fix previous/next for tasks ([#1414](https://github.com/provusinc/quoting/issues/1414)) ([1f928ea](https://github.com/provusinc/quoting/commit/1f928ea127e0b5c930d38b1421fe23fe959b6952))

## [2.37.0-next.56](https://github.com/provusinc/quoting/compare/v2.37.0-next.55...v2.37.0-next.56) (2022-08-16)


### Features

* **psq-5455:** update calculation duration on page load and scope param change ([#1412](https://github.com/provusinc/quoting/issues/1412)) ([2d73267](https://github.com/provusinc/quoting/commit/2d73267e381499fbde89d14b1f5cbe69c123a208))


### Bug Fixes

* **psq-5339:** race condition causing adjustment to not merge back in ([#1413](https://github.com/provusinc/quoting/issues/1413)) ([126d126](https://github.com/provusinc/quoting/commit/126d126f66890011e70370519708835667af175b))

## [2.37.0-next.55](https://github.com/provusinc/quoting/compare/v2.37.0-next.54...v2.37.0-next.55) (2022-08-16)


### Bug Fixes

* **psq-5488:** fix references to load records on the estimate ([#1410](https://github.com/provusinc/quoting/issues/1410)) ([8f2c772](https://github.com/provusinc/quoting/commit/8f2c772ae8a73cd2fc83300515468018d91382cd))
* **psq-5488:** fixed promise then ([#1411](https://github.com/provusinc/quoting/issues/1411)) ([56299bc](https://github.com/provusinc/quoting/commit/56299bc87c69a4578af5f9e50a5c2af86005b97a))

## [2.37.0-next.54](https://github.com/provusinc/quoting/compare/v2.37.0-next.53...v2.37.0-next.54) (2022-08-16)


### Features

* **psq-5487:** support multiple tokens or user input ([#1408](https://github.com/provusinc/quoting/issues/1408)) ([4f461f3](https://github.com/provusinc/quoting/commit/4f461f3e0a5534cf1b8ec0fa9d5e52cc075eb842))

## [2.37.0-next.53](https://github.com/provusinc/quoting/compare/v2.37.0-next.52...v2.37.0-next.53) (2022-08-16)


### Bug Fixes

* **import data table:** change attribute name ([a30d789](https://github.com/provusinc/quoting/commit/a30d789856882de45056cad3cfb556412a2697b1))

## [2.37.0-next.52](https://github.com/provusinc/quoting/compare/v2.37.0-next.51...v2.37.0-next.52) (2022-08-16)


### Features

* adding namespace accessible to clone estimate and create quote for integration ([#1407](https://github.com/provusinc/quoting/issues/1407)) ([8e8e1fe](https://github.com/provusinc/quoting/commit/8e8e1fee5e3b8de2a5ad0b5a8a2c96891203932f))


### Bug Fixes

* **psq-5231:** fix for cola rates not populating service year ([#1391](https://github.com/provusinc/quoting/issues/1391)) ([527ff59](https://github.com/provusinc/quoting/commit/527ff5997dc234433e6e2bb9bea871d2ea7b7d8b))
* **psq-5493:** row is imported in the wrong location ([#1409](https://github.com/provusinc/quoting/issues/1409)) ([4257070](https://github.com/provusinc/quoting/commit/42570709af8abb6b318e8110b8eac9b3f2ae68a3))

## [2.37.0-next.51](https://github.com/provusinc/quoting/compare/v2.37.0-next.50...v2.37.0-next.51) (2022-08-16)


### Bug Fixes

* **psq-5486:** fix references to this ([8d7fc02](https://github.com/provusinc/quoting/commit/8d7fc024fad561766ca242cef5556a77bac42967))

## [2.37.0-next.50](https://github.com/provusinc/quoting/compare/v2.37.0-next.49...v2.37.0-next.50) (2022-08-16)


### Features

* **import roles:** bring the feature to a working state ([ac6b06a](https://github.com/provusinc/quoting/commit/ac6b06a40456d929cd973e81ec45164db6c4a024))

## [2.37.0-next.49](https://github.com/provusinc/quoting/compare/v2.37.0-next.48...v2.37.0-next.49) (2022-08-15)


### Bug Fixes

* **psq-5483:** compare lowercased hashtags during dupe detection ([#1406](https://github.com/provusinc/quoting/issues/1406)) ([748048c](https://github.com/provusinc/quoting/commit/748048cb019061147cbcc5852f6b05b7f67d0f0a))

## [2.37.0-next.48](https://github.com/provusinc/quoting/compare/v2.37.0-next.47...v2.37.0-next.48) (2022-08-15)


### Features

* **psq-5455:** change estimated duration formula to return a map ([#1405](https://github.com/provusinc/quoting/issues/1405)) ([6bdcfd2](https://github.com/provusinc/quoting/commit/6bdcfd2733eed7eef57ba20a795bbfbc40595e4f))

## [2.37.0-next.47](https://github.com/provusinc/quoting/compare/v2.37.0-next.46...v2.37.0-next.47) (2022-08-15)


### Bug Fixes

* **psq-5485:** Task Parameter Input is Hidden When it Should be Visible ([#1404](https://github.com/provusinc/quoting/issues/1404)) ([e9b0101](https://github.com/provusinc/quoting/commit/e9b0101352c84abd056271f7b9c491e0cf3b053a))

## [2.37.0-next.46](https://github.com/provusinc/quoting/compare/v2.37.0-next.45...v2.37.0-next.46) (2022-08-15)


### Bug Fixes

* **psq-5484:** improper scope reference in estimate code breaks task dialog ([#1403](https://github.com/provusinc/quoting/issues/1403)) ([ee32075](https://github.com/provusinc/quoting/commit/ee32075c6f914734cc93ee53694338078402e262))

## [2.37.0-next.45](https://github.com/provusinc/quoting/compare/v2.37.0-next.44...v2.37.0-next.45) (2022-08-14)


### Bug Fixes

* revert vs code settings ([#1402](https://github.com/provusinc/quoting/issues/1402)) ([75a6a14](https://github.com/provusinc/quoting/commit/75a6a140069f3f05d293f293d5d65af320022554))

## [2.37.0-next.44](https://github.com/provusinc/quoting/compare/v2.37.0-next.43...v2.37.0-next.44) (2022-08-13)


### Features

* apex code and scripts for generating estimate data ([#1397](https://github.com/provusinc/quoting/issues/1397)) ([31fa224](https://github.com/provusinc/quoting/commit/31fa224f7d3fde874c0eee26dd0b6702c42f9ecf))
* **psq-5453:** support #USER_INPUT ([#1400](https://github.com/provusinc/quoting/issues/1400)) ([b8a1c30](https://github.com/provusinc/quoting/commit/b8a1c304305be6eb0328267fcd89efca7406cf71))


### Bug Fixes

* **psq-5426:** allocate quote item cells directly from item duration ([#1398](https://github.com/provusinc/quoting/issues/1398)) ([9411115](https://github.com/provusinc/quoting/commit/941111577825df3396ed186cf869db6acfb2083d))
* **psq-5427:** unit test coverage on defect scenario ([#1396](https://github.com/provusinc/quoting/issues/1396)) ([50e9432](https://github.com/provusinc/quoting/commit/50e9432c72b55bb498b1f79c5ac84c75736d28f4))


### Performance Improvements

* insert/update adjustment records outside for loop ([#1399](https://github.com/provusinc/quoting/issues/1399)) ([e40b5f5](https://github.com/provusinc/quoting/commit/e40b5f5ed6f0e9d5e6e680711edcff602da6365c))

## [2.37.0-next.43](https://github.com/provusinc/quoting/compare/v2.37.0-next.42...v2.37.0-next.43) (2022-08-12)


### Features

* **psq-5210:** update calculated duration with hashtag support ([#1395](https://github.com/provusinc/quoting/issues/1395)) ([b239a8d](https://github.com/provusinc/quoting/commit/b239a8d1cc45d56576015db93a3e2680e551616a))


### Bug Fixes

* **psq-5460:** quote grid total amount does not include add-ons ([#1394](https://github.com/provusinc/quoting/issues/1394)) ([6dce1fd](https://github.com/provusinc/quoting/commit/6dce1fd0f583b11e10a3fd1c3dcb617ed86ab11a))

## [2.37.0-next.42](https://github.com/provusinc/quoting/compare/v2.37.0-next.41...v2.37.0-next.42) (2022-08-12)


### Bug Fixes

* **psq-5478:** hyperformula must evaluate a string ([#1393](https://github.com/provusinc/quoting/issues/1393)) ([8c81af5](https://github.com/provusinc/quoting/commit/8c81af52004480a5b749c19fefd3d8d0dc14d91d))

## [2.37.0-next.41](https://github.com/provusinc/quoting/compare/v2.37.0-next.40...v2.37.0-next.41) (2022-08-12)


### Features

* **psq-5209:** strip hashtag from expression before adding it into HF ([#1390](https://github.com/provusinc/quoting/issues/1390)) ([56598fc](https://github.com/provusinc/quoting/commit/56598fc82e1701d3969dee51bc17e58a73318a7e))

## [2.37.0-next.40](https://github.com/provusinc/quoting/compare/v2.37.0-next.39...v2.37.0-next.40) (2022-08-12)


### Bug Fixes

* **psq-5231:** fix for cola rates not populating service year ([#1383](https://github.com/provusinc/quoting/issues/1383)) ([895b38c](https://github.com/provusinc/quoting/commit/895b38cf80219418bc10f666a200fa6391f483a3))
* **psq-5427:** use period hours instead of available hours in quote cell ([#1388](https://github.com/provusinc/quoting/issues/1388)) ([77322f8](https://github.com/provusinc/quoting/commit/77322f82c16a4d9bf4aff1e4e234e0631bc9a840))

## [2.37.0-next.39](https://github.com/provusinc/quoting/compare/v2.37.0-next.38...v2.37.0-next.39) (2022-08-11)


### Features

* **psq-5209:** update hyperformula expressions ([#1387](https://github.com/provusinc/quoting/issues/1387)) ([7f0a0aa](https://github.com/provusinc/quoting/commit/7f0a0aafd3f308c101ee3ae39dd2a50463e6512c))

## [2.37.0-next.38](https://github.com/provusinc/quoting/compare/v2.37.0-next.37...v2.37.0-next.38) (2022-08-11)


### Bug Fixes

* **estimatetreegrid:** wrap formula calculations in feature flag ([#1386](https://github.com/provusinc/quoting/issues/1386)) ([665cac3](https://github.com/provusinc/quoting/commit/665cac3d293c5fea591096fa121aa8ecb5a3e3d7))
* **psq-5416:** end date calc doesnt consider split allocation ([#1384](https://github.com/provusinc/quoting/issues/1384)) ([06fd1ea](https://github.com/provusinc/quoting/commit/06fd1ea80d2f1971a178f53c0cd9c91250cf427c))
* **psq-5452:** display object field labels ([#1385](https://github.com/provusinc/quoting/issues/1385)) ([f317327](https://github.com/provusinc/quoting/commit/f3173271f203e35f43a83930806bc315a18375bb))

## [2.37.0-next.37](https://github.com/provusinc/quoting/compare/v2.37.0-next.36...v2.37.0-next.37) (2022-08-11)


### Features

* **recurring hours:** recurring hours code not working with quarters ([#1382](https://github.com/provusinc/quoting/issues/1382)) ([1c9a864](https://github.com/provusinc/quoting/commit/1c9a864971f5e854d88920ddab4cce844b26380d))


### Bug Fixes

* **recurring hours:** no negative values in the input fields ([#1381](https://github.com/provusinc/quoting/issues/1381)) ([7258296](https://github.com/provusinc/quoting/commit/725829656b032bec2026f10284949d7dd617af1d))

## [2.37.0-next.36](https://github.com/provusinc/quoting/compare/v2.37.0-next.35...v2.37.0-next.36) (2022-08-11)


### Bug Fixes

* revert webpack changes ([40f2bc8](https://github.com/provusinc/quoting/commit/40f2bc82895c620450f052d0ebc65f438acf966c))

## [2.37.0-next.35](https://github.com/provusinc/quoting/compare/v2.37.0-next.34...v2.37.0-next.35) (2022-08-11)


### Bug Fixes

* **estimatetreegrid:** updated reference to field api names ([#1380](https://github.com/provusinc/quoting/issues/1380)) ([dfd2387](https://github.com/provusinc/quoting/commit/dfd2387abf182919e0bc7fa80df7a1f5afc6db9f))

## [2.37.0-next.34](https://github.com/provusinc/quoting/compare/v2.37.0-next.33...v2.37.0-next.34) (2022-08-11)


### Features

* **psq-5202:** evaluate estimate duration formula ([#1379](https://github.com/provusinc/quoting/issues/1379)) ([c8490db](https://github.com/provusinc/quoting/commit/c8490dbbd46a8ad504d97b9444ca0b448e1ac979))

## [2.37.0-next.33](https://github.com/provusinc/quoting/compare/v2.37.0-next.32...v2.37.0-next.33) (2022-08-11)


### Features

* **psq-5206:** class to handle loading hashtags and their values ([#1376](https://github.com/provusinc/quoting/issues/1376)) ([1066e81](https://github.com/provusinc/quoting/commit/1066e81b1e2ca3df076948c19c187ca3904079cb))
* **psq-5208:** update hashtag dictionary upon save of scope parameters ([#1377](https://github.com/provusinc/quoting/issues/1377)) ([9704e96](https://github.com/provusinc/quoting/commit/9704e96a89603f110dedc02de0c9313408ce7b9a))

## [2.37.0-next.32](https://github.com/provusinc/quoting/compare/v2.37.0-next.31...v2.37.0-next.32) (2022-08-10)


### Features

* **psq-3396:**  opportunity sync changes when disassociated ([#1305](https://github.com/provusinc/quoting/issues/1305)) ([b483cf9](https://github.com/provusinc/quoting/commit/b483cf9a63ac9cf9dd5e2b8437a215184c1c51cd))
* **psq-5207:** generate hashtag dictionary using scope params ([#1375](https://github.com/provusinc/quoting/issues/1375)) ([de9eb61](https://github.com/provusinc/quoting/commit/de9eb61d4cc3eb479ac2d36c376063f2c56fd446))


### Bug Fixes

* **psq-5182:** display the status path for scenario quote on scenario rejection ([#1373](https://github.com/provusinc/quoting/issues/1373)) ([1c3549a](https://github.com/provusinc/quoting/commit/1c3549a419dc447f0b31643674d6f113f2adb3d5))

## [2.37.0-next.31](https://github.com/provusinc/quoting/compare/v2.37.0-next.30...v2.37.0-next.31) (2022-08-10)


### Features

* **psq-5201:** add the hyper formula js library as a static resource using webpack ([#1374](https://github.com/provusinc/quoting/issues/1374)) ([0869d99](https://github.com/provusinc/quoting/commit/0869d99414e597c2e502c22299e4928033c99cd9))

## [2.37.0-next.30](https://github.com/provusinc/quoting/compare/v2.37.0-next.29...v2.37.0-next.30) (2022-08-10)


### Features

* **psq-5130:** add hyperformulajs as a static resource ([#1370](https://github.com/provusinc/quoting/issues/1370)) ([9135fc5](https://github.com/provusinc/quoting/commit/9135fc5485743b7af517b06c20fc2a575d8bb8ec))


### Performance Improvements

* remove debounce from cell onchange ([#1371](https://github.com/provusinc/quoting/issues/1371)) ([6d1ad81](https://github.com/provusinc/quoting/commit/6d1ad818e75c4975e7d355372702666766ee5ff4))

## [2.37.0-next.29](https://github.com/provusinc/quoting/compare/v2.37.0-next.28...v2.37.0-next.29) (2022-08-10)


### Features

* **psq-5122:** convert headcount to hours during quote item cell creation ([#1367](https://github.com/provusinc/quoting/issues/1367)) ([dad7e01](https://github.com/provusinc/quoting/commit/dad7e018e215ecec2ac32cba1f5cc82dbc79da72))


### Bug Fixes

* **psq-5338:** remove quote item named range from cache and reprice all ([#1369](https://github.com/provusinc/quoting/issues/1369)) ([0b1c96c](https://github.com/provusinc/quoting/commit/0b1c96c09ffce99fa45c98462a25f1c177b2508b))

## [2.37.0-next.28](https://github.com/provusinc/quoting/compare/v2.37.0-next.27...v2.37.0-next.28) (2022-08-09)


### Bug Fixes

* **psq-5259:** period span allocation tests ([#1366](https://github.com/provusinc/quoting/issues/1366)) ([8642837](https://github.com/provusinc/quoting/commit/86428376f4be775c08f2514f76533297edb7a83c))

## [2.37.0-next.27](https://github.com/provusinc/quoting/compare/v2.37.0-next.26...v2.37.0-next.27) (2022-08-09)


### Bug Fixes

* **psq-5259:** period span allocation updates for partial availability ([#1365](https://github.com/provusinc/quoting/issues/1365)) ([890a78d](https://github.com/provusinc/quoting/commit/890a78de253439b8bdac79471a4422aea6a2d0fe))

## [2.37.0-next.26](https://github.com/provusinc/quoting/compare/v2.37.0-next.25...v2.37.0-next.26) (2022-08-09)


### Bug Fixes

* **psq-5326:** calculate grand total on load of converted estimate quote ([#1363](https://github.com/provusinc/quoting/issues/1363)) ([3cd20c7](https://github.com/provusinc/quoting/commit/3cd20c70196909e6684b420316531380e23418d6))

## [2.37.0-next.25](https://github.com/provusinc/quoting/compare/v2.37.0-next.24...v2.37.0-next.25) (2022-08-09)


### Features

* **psq-5126:** create new input field for estimated duration formula ([#1362](https://github.com/provusinc/quoting/issues/1362)) ([8006e13](https://github.com/provusinc/quoting/commit/8006e1372d5e1fb338f3b5757bb23145f99ccb02))

## [2.37.0-next.24](https://github.com/provusinc/quoting/compare/v2.37.0-next.23...v2.37.0-next.24) (2022-08-09)


### Features

* **psq-5125:** update labels in estimate template ([#1358](https://github.com/provusinc/quoting/issues/1358)) ([673c962](https://github.com/provusinc/quoting/commit/673c962e5fca691afbd811c32f773811ee92dce5))
* **psq-5127:** added feature flag for duration formula ([#1359](https://github.com/provusinc/quoting/issues/1359)) ([305bfb4](https://github.com/provusinc/quoting/commit/305bfb40730f11b8a3a75a1fad74f6db420dce5a))
* **psq-5129:** added formula field to api response ([#1360](https://github.com/provusinc/quoting/issues/1360)) ([fc7084b](https://github.com/provusinc/quoting/commit/fc7084b068dc67f6e58027e77044b2e4737121cb))
* **psq-5325:** fixed consistency in cancel/save buttons ([#1361](https://github.com/provusinc/quoting/issues/1361)) ([7bade2e](https://github.com/provusinc/quoting/commit/7bade2e8d45636ae9867d6d7515a58befd3186f6))


### Bug Fixes

* **psq-5117, psq-4771:** add period clearing totals issue ([#1357](https://github.com/provusinc/quoting/issues/1357)) ([23dd242](https://github.com/provusinc/quoting/commit/23dd24257458764e4f867beb1b971fc7323579bc))
* **psq-5280:** fix priority order of location discounts ([#1356](https://github.com/provusinc/quoting/issues/1356)) ([cec4e9e](https://github.com/provusinc/quoting/commit/cec4e9e631cec28692f49a3c50173c3c3404df3b))

## [2.37.0-next.23](https://github.com/provusinc/quoting/compare/v2.37.0-next.22...v2.37.0-next.23) (2022-08-08)


### Bug Fixes

* **psq-5232:** end date calc is based on the wron gnumber ([bf0d469](https://github.com/provusinc/quoting/commit/bf0d469db43346fe1a2fbd052a252fa513449a43))

## [2.37.0-next.22](https://github.com/provusinc/quoting/compare/v2.37.0-next.21...v2.37.0-next.22) (2022-08-08)


### Bug Fixes

* use the rounded value when applying tiers ([a38e4df](https://github.com/provusinc/quoting/commit/a38e4dffec667c4fb8230388337db5331c44b3f0))

## [2.37.0-next.21](https://github.com/provusinc/quoting/compare/v2.37.0-next.20...v2.37.0-next.21) (2022-08-08)


### Bug Fixes

* **psq-4504:** handled  quote sync to opportunity when no estimate linked to quote ([#1342](https://github.com/provusinc/quoting/issues/1342)) ([e3bb778](https://github.com/provusinc/quoting/commit/e3bb7781fac375232605c087d3f8ebaec8562b57))
* **psq-5197:** onflowfinish collision due to same message boundary ([#1355](https://github.com/provusinc/quoting/issues/1355)) ([cae61dc](https://github.com/provusinc/quoting/commit/cae61dc9f7d88c96e371d7bef19098e74f7c95de))
* **psq-5279:** set the labor unit value by default on page load ([1d4b7b5](https://github.com/provusinc/quoting/commit/1d4b7b5b5630060419c9bf5428ca1bedcb98ef62))

## [2.37.0-next.20](https://github.com/provusinc/quoting/compare/v2.37.0-next.19...v2.37.0-next.20) (2022-08-08)


### Features

* **sutff:** release stuff ([4b8b1e5](https://github.com/provusinc/quoting/commit/4b8b1e53ceea3a1f50cbb46d8033b377f7874530))

## [2.37.0-next.19](https://github.com/provusinc/quoting/compare/v2.37.0-next.18...v2.37.0-next.19) (2022-08-08)


### Bug Fixes

* **psq-5108:** do not trigger discount below first tier our outside of last tier ([c3c6199](https://github.com/provusinc/quoting/commit/c3c6199361421f87d23f00afd0b4a43973386f8d))

## [2.37.0-next.18](https://github.com/provusinc/quoting/compare/v2.37.0-next.17...v2.37.0-next.18) (2022-08-08)


### Bug Fixes

* **psq-4537:** restrict availability to activity group ([9cd5bbd](https://github.com/provusinc/quoting/commit/9cd5bbdd353ea4e437e1f2c25073b5e48bf157a8))

## [2.37.0-next.17](https://github.com/provusinc/quoting/compare/v2.37.0-next.16...v2.37.0-next.17) (2022-08-08)


### Bug Fixes

* **psq-5242:** allow updating location discount ([#1354](https://github.com/provusinc/quoting/issues/1354)) ([124f858](https://github.com/provusinc/quoting/commit/124f858c597ebca7e8358bc6510cea2634225529))

## [2.37.0-next.16](https://github.com/provusinc/quoting/compare/v2.37.0-next.15...v2.37.0-next.16) (2022-08-08)


### Bug Fixes

* fix the contingency check ([d4d4d66](https://github.com/provusinc/quoting/commit/d4d4d66f25c923db5e09f558f804eaeaa2ead101))

## [2.37.0-next.15](https://github.com/provusinc/quoting/compare/v2.37.0-next.14...v2.37.0-next.15) (2022-08-08)


### Features

* **remove feature flags:** remove feature flags for cola and add periods ([88839aa](https://github.com/provusinc/quoting/commit/88839aa3c20b66a70f3b96c813c952b68e38fde7))


### Bug Fixes

* null ptr in discount dialog ([f403ed1](https://github.com/provusinc/quoting/commit/f403ed109d29844db7d869a48aea193b76061a51))
* null ptr in discount dialog ([3fb65dc](https://github.com/provusinc/quoting/commit/3fb65dcbdb8cfd1354be05c5c87627df32ecaea5))
* null ptr in discount dialog ([e7ff369](https://github.com/provusinc/quoting/commit/e7ff3696fa3cfac57668abf456f5bdcbf652b62f))

## [2.37.0-next.14](https://github.com/provusinc/quoting/compare/v2.37.0-next.13...v2.37.0-next.14) (2022-08-08)


### Features

* **psq-5234:** hide tabs if quote discount is in contingency mode ([#1353](https://github.com/provusinc/quoting/issues/1353)) ([018ee72](https://github.com/provusinc/quoting/commit/018ee72d9444e22ff7a4d16f87937d60ad79cade))


### Bug Fixes

* **location discount:** location discount refactor ([#1351](https://github.com/provusinc/quoting/issues/1351)) ([344fd58](https://github.com/provusinc/quoting/commit/344fd58a34621aedfdaa7996e502650003a2647b))
* **psq-5213:** round revenue to next whole integer ([#1352](https://github.com/provusinc/quoting/issues/1352)) ([9ed8be0](https://github.com/provusinc/quoting/commit/9ed8be06707d3fb88730a874fc079651ee376664))

## [2.37.0-next.13](https://github.com/provusinc/quoting/compare/v2.37.0-next.12...v2.37.0-next.13) (2022-08-06)


### Features

* **recurring hours:** refactored recurring hours to account for hours as labor units ([#1350](https://github.com/provusinc/quoting/issues/1350)) ([b7e2eb5](https://github.com/provusinc/quoting/commit/b7e2eb5f4e5fc75626a1007d4ceb9a93bcf66f19))


### Bug Fixes

* **psq-5236:** update styles to reduce padding and font weight ([eaf0603](https://github.com/provusinc/quoting/commit/eaf0603b4cda420242d34733af6a21d49453b505))
* **recurring hours:** re-add missing decorator ([3603819](https://github.com/provusinc/quoting/commit/36038192ea573eabd54990bd50c7138600821866))

## [2.37.0-next.13](https://github.com/provusinc/quoting/compare/v2.37.0-next.12...v2.37.0-next.13) (2022-08-06)


### Features

* **recurring hours:** refactored recurring hours to account for hours as labor units ([#1350](https://github.com/provusinc/quoting/issues/1350)) ([b7e2eb5](https://github.com/provusinc/quoting/commit/b7e2eb5f4e5fc75626a1007d4ceb9a93bcf66f19))


### Bug Fixes

* **recurring hours:** re-add missing decorator ([3603819](https://github.com/provusinc/quoting/commit/36038192ea573eabd54990bd50c7138600821866))

## [2.37.0-next.14](https://github.com/provusinc/quoting/compare/v2.37.0-next.13...v2.37.0-next.14) (2022-08-06)

### Features

- **recurring hours:** fix the recurring ours decorators ([adb3419](https://github.com/provusinc/quoting/commit/adb3419fbf4cecb54f9a3aab9440e564709eaec0))

### Bug Fixes

- **psq-4449:** re-add removed public property ([eb4fc6d](https://github.com/provusinc/quoting/commit/eb4fc6d778e890720bf1d04ba33e15d42b96ec41))

## [2.37.0-next.13](https://github.com/provusinc/quoting/compare/v2.37.0-next.12...v2.37.0-next.13) (2022-08-06)

### Features

- **recurring hours:** refactored recurring hours to account for hours as labor units ([#1350](https://github.com/provusinc/quoting/issues/1350)) ([b7e2eb5](https://github.com/provusinc/quoting/commit/b7e2eb5f4e5fc75626a1007d4ceb9a93bcf66f19))

## [2.37.0-next.12](https://github.com/provusinc/quoting/compare/v2.37.0-next.11...v2.37.0-next.12) (2022-08-06)

### Features

- **psq-5121:** introduce labor units pick list in estimate conversion screen ([#1349](https://github.com/provusinc/quoting/issues/1349)) ([8172ac2](https://github.com/provusinc/quoting/commit/8172ac2626fb115b4870989af33e51e549493dc9))

## [2.37.0-next.11](https://github.com/provusinc/quoting/compare/v2.37.0-next.10...v2.37.0-next.11) (2022-08-06)

### Bug Fixes

- **psq-4537:** availability percentage for sync estimate to quote ([#1348](https://github.com/provusinc/quoting/issues/1348)) ([2a22622](https://github.com/provusinc/quoting/commit/2a2262265675f466642f362ac54d7a15867583a9))

## [2.37.0-next.10](https://github.com/provusinc/quoting/compare/v2.37.0-next.9...v2.37.0-next.10) (2022-08-06)

### Features

- **psq-4537:** stitch resource availability components together ([#1347](https://github.com/provusinc/quoting/issues/1347)) ([63d219a](https://github.com/provusinc/quoting/commit/63d219af495fc5afc88b201abae4969fd8cdd2e3))

## [2.37.0-next.9](https://github.com/provusinc/quoting/compare/v2.37.0-next.8...v2.37.0-next.9) (2022-08-05)

### Features

- **psq-5078:** api to save/retrieve resource availability ([#1343](https://github.com/provusinc/quoting/issues/1343)) ([3531519](https://github.com/provusinc/quoting/commit/35315199796a73efc8d69f53ecaaf33cb42538af))
- **psq-5081:** add dialog to capture resource availability ([#1344](https://github.com/provusinc/quoting/issues/1344)) ([d3e982a](https://github.com/provusinc/quoting/commit/d3e982a38ad4666ef8dc3ef7c3dbf157758cf024))
- **psq-5082:** estimate 2 quote conversion logic for availability ([#1345](https://github.com/provusinc/quoting/issues/1345)) ([28acbf7](https://github.com/provusinc/quoting/commit/28acbf7ba18ec46457c6088ad88c4b701dfab6d4))

## [2.37.0-next.8](https://github.com/provusinc/quoting/compare/v2.37.0-next.7...v2.37.0-next.8) (2022-08-05)

### Features

- **psq-5058:** base dto refactoring, introduce resource availability ([#1339](https://github.com/provusinc/quoting/issues/1339)) ([34a3fce](https://github.com/provusinc/quoting/commit/34a3fce3b80b40c93bbb27502235f4bf693cf503))

### Bug Fixes

- **psq-5080:** account for null availability percentage ([#1341](https://github.com/provusinc/quoting/issues/1341)) ([813e51b](https://github.com/provusinc/quoting/commit/813e51b71fe430a7961ff8c73412dd8312422b52))
- **psq-5115:** updated sum of location discount adjustments ([#1333](https://github.com/provusinc/quoting/issues/1333)) ([a30a0e1](https://github.com/provusinc/quoting/commit/a30a0e19cef874b45fe9c7ed0f93e90c14364344))

## [2.37.0-next.7](https://github.com/provusinc/quoting/compare/v2.37.0-next.6...v2.37.0-next.7) (2022-08-04)

### Features

- **psq-5079:** update e2q end date calculation to include availability percentage ([#1338](https://github.com/provusinc/quoting/issues/1338)) ([1c99825](https://github.com/provusinc/quoting/commit/1c99825868506c62307e4d3b97dad89701e7d8b8))

## [2.37.0-next.6](https://github.com/provusinc/quoting/compare/v2.37.0-next.5...v2.37.0-next.6) (2022-08-04)

### Features

- **psq-5057:** add new menu item specify availability to resource summary dialog ([#1336](https://github.com/provusinc/quoting/issues/1336)) ([324476a](https://github.com/provusinc/quoting/commit/324476a8f2c379ecc487d173bd1fb70491b7f6b1))

### Bug Fixes

- **psq-5189:** incorrect year formatter adds a year ([#1337](https://github.com/provusinc/quoting/issues/1337)) ([359e501](https://github.com/provusinc/quoting/commit/359e5013bb22b60c21f905e9287f4297c1749a1d))

## [2.37.0-next.5](https://github.com/provusinc/quoting/compare/v2.37.0-next.4...v2.37.0-next.5) (2022-08-04)

### Features

- **psq-5080:** introduce resource availability data model ([#1335](https://github.com/provusinc/quoting/issues/1335)) ([9319733](https://github.com/provusinc/quoting/commit/9319733979cc5a725eba902cc87ebaa4a72ab0c3))

## [2.37.0-next.4](https://github.com/provusinc/quoting/compare/v2.37.0-next.3...v2.37.0-next.4) (2022-08-04)

### Bug Fixes

- **psq-4436:** restrict duplicate added values for the data type picklist and integer tier after clone estimate template ([#1325](https://github.com/provusinc/quoting/issues/1325)) ([505b885](https://github.com/provusinc/quoting/commit/505b8852e1e0c567507cefc83051be4990c87a85))

## [2.37.0-next.3](https://github.com/provusinc/quoting/compare/v2.37.0-next.2...v2.37.0-next.3) (2022-08-04)

### Bug Fixes

- **psq-5113:** apply volume discount after section cell shift ([#1331](https://github.com/provusinc/quoting/issues/1331)) ([ec3fade](https://github.com/provusinc/quoting/commit/ec3fade8a5cc31562f189df861de11f86bd84914))
- **psq-5116:** apply volume discount after adding recurring hours ([#1332](https://github.com/provusinc/quoting/issues/1332)) ([98da5f6](https://github.com/provusinc/quoting/commit/98da5f68f0924763b672ea0b009046eb642c072c))

## [2.37.0-next.2](https://github.com/provusinc/quoting/compare/v2.37.0-next.1...v2.37.0-next.2) (2022-08-03)

### Bug Fixes

- **psq-5038:** should not remove unsaved adjustment from cache when applying discounts ([#1329](https://github.com/provusinc/quoting/issues/1329)) ([1163479](https://github.com/provusinc/quoting/commit/1163479038cb4e639764ffac39646a9ce21bb21a))
- **psq-5182:** updated status field on approval request object ([#1327](https://github.com/provusinc/quoting/issues/1327)) ([b46bfd7](https://github.com/provusinc/quoting/commit/b46bfd7ad551423d031f979193688c5eaa143218))
- **quote-grid:** cell edit performance improvements ([#1330](https://github.com/provusinc/quoting/issues/1330)) ([be422a5](https://github.com/provusinc/quoting/commit/be422a5a9f27b95f263a5c6ef1e4a39472dc22c1))

## [2.37.0-next.1](https://github.com/provusinc/quoting/compare/v2.36.0...v2.37.0-next.1) (2022-08-03)

### Features

- **psq-5053:** duplicate adjustments are created ([#1324](https://github.com/provusinc/quoting/issues/1324)) ([718ec2f](https://github.com/provusinc/quoting/commit/718ec2ffa79887637b3bfc10a85b50be176c9290))

## [2.36.0-next.1](https://github.com/provusinc/quoting/compare/v2.35.0...v2.36.0-next.1) (2022-08-02)

### Features

- **custom labels:** cleanup custom labels ([#1315](https://github.com/provusinc/quoting/issues/1315)) ([dd14f3e](https://github.com/provusinc/quoting/commit/dd14f3edc3f9e6bf9c84d9b7d755ba199acfda61))
- **location discount review:** location discount review dtos + stub … ([#1260](https://github.com/provusinc/quoting/issues/1260)) ([e6a91be](https://github.com/provusinc/quoting/commit/e6a91be5303a43bfaa8dfd26f44ae2b38bb305df))
- **location discount:** refactored locationleveldiscount into just locationdiscount ([#1284](https://github.com/provusinc/quoting/issues/1284)) ([2d03b02](https://github.com/provusinc/quoting/commit/2d03b02f23f61e941b80f38fc39b5667b3ab0c72))
- **location level discount:** created initial dtos and stubbed api functions for mock data ([#1247](https://github.com/provusinc/quoting/issues/1247)) ([a6f0ad7](https://github.com/provusinc/quoting/commit/a6f0ad7207a4d1c8e82befca00e708f3a69a65ee))
- **location level discounts:** added transformation methods to dto and get retrieve service methods ([#1250](https://github.com/provusinc/quoting/issues/1250)) ([40bea6a](https://github.com/provusinc/quoting/commit/40bea6a6b5973f9461a5b641f9ed9392c1da7cb1))
- **named range:** add unbilled labor and add on named ranges ([919fb02](https://github.com/provusinc/quoting/commit/919fb024b6c87c46bfa1d8ed8cb848b37761ce66))
- **periods alignment:** remove unused period alignments ([eeb8fb7](https://github.com/provusinc/quoting/commit/eeb8fb76818c23dbe61a706beb1744e43216f979))
- **ps-3399:** support total estimated amount in service recommendations ([#1255](https://github.com/provusinc/quoting/issues/1255)) ([3c6c177](https://github.com/provusinc/quoting/commit/3c6c1770d1b97db488c438c476fb2791950e0ee9))
- **psq-4154:** add review volume discount menu item to delta menu for cola rate dialog ([#1256](https://github.com/provusinc/quoting/issues/1256)) ([0569f83](https://github.com/provusinc/quoting/commit/0569f83f1b29203ba8f55cd74668e64de620b997))
- **psq-4154:** create totals rows, minimum modal height ([#1298](https://github.com/provusinc/quoting/issues/1298)) ([b57901e](https://github.com/provusinc/quoting/commit/b57901ec247f552673f8baa84c0787194684e324))
- **psq-4154:** fix discount percentage and discount amount display ([#1289](https://github.com/provusinc/quoting/issues/1289)) ([ff2bf8c](https://github.com/provusinc/quoting/commit/ff2bf8c753034e355af02eee26ab90a296b89603))
- **psq-4154:** fix min/max revenue labels ([#1290](https://github.com/provusinc/quoting/issues/1290)) ([b9495e8](https://github.com/provusinc/quoting/commit/b9495e80a1b5a3e4f6ff750492d747b56fe8349e))
- **psq-4179:** ability to create labor revenue volume discount ([#1292](https://github.com/provusinc/quoting/issues/1292)) ([172e005](https://github.com/provusinc/quoting/commit/172e005f56aef5bf8d566a61f525a5ad7879069a))
- **psq-4179:** labor revenue calculation, period/group name fixes ([#1297](https://github.com/provusinc/quoting/issues/1297)) ([ece3d07](https://github.com/provusinc/quoting/commit/ece3d0772c427e31f7701d686f533d4945c4b443))
- **psq-4657:** calculate discount correctly for quote and period tota… ([#1277](https://github.com/provusinc/quoting/issues/1277)) ([6516d92](https://github.com/provusinc/quoting/commit/6516d922ce752314ae0c6b947050dbdf767b6a1e))
- **psq-4816:** added location discount tab placeholder ([#1245](https://github.com/provusinc/quoting/issues/1245)) ([1cf2876](https://github.com/provusinc/quoting/commit/1cf28760c3937119a6eaff962e500788326945a7))
- **psq-4817:** implement location discounts table ([#1266](https://github.com/provusinc/quoting/issues/1266)) ([7d186eb](https://github.com/provusinc/quoting/commit/7d186eba69febe5c424110328c089c035842f573))
- **psq-4818:** add location to named ranges and properly retrieve from new named ranges ([#1306](https://github.com/provusinc/quoting/issues/1306)) ([4372cb6](https://github.com/provusinc/quoting/commit/4372cb6eb9bfe4713ace1a58991322301fed3cdb))
- **psq-4818:** Calculate and Apply Location Discount Adjustment ([#1299](https://github.com/provusinc/quoting/issues/1299)) ([a990e61](https://github.com/provusinc/quoting/commit/a990e61e6a8b356db9c0b3dac2003b4537214856)), closes [#1277](https://github.com/provusinc/quoting/issues/1277)
- **psq-4818:** updated add/remove adjustments for location discounts ([#1302](https://github.com/provusinc/quoting/issues/1302)) ([c5fda5b](https://github.com/provusinc/quoting/commit/c5fda5b35ba14743d3ba69f0f01a35a8074993ac))
- **psq-4824:** refactor existing global cola admin table ([#1253](https://github.com/provusinc/quoting/issues/1253)) ([869a17c](https://github.com/provusinc/quoting/commit/869a17c996bb2e05df97e1d584ee93a3fc69243d))
- **psq-4827:** create adjustment volume discount object ([#1264](https://github.com/provusinc/quoting/issues/1264)) ([134bfe7](https://github.com/provusinc/quoting/commit/134bfe79b893c12af9290dd317dcf5c337071b52))
- **psq-4828:** create adjustment volume discount tier junction ([#1267](https://github.com/provusinc/quoting/issues/1267)) ([4980fbb](https://github.com/provusinc/quoting/commit/4980fbb4125ccaaf3aee2f2596e7c7c970ec5c29))
- **psq-4830:** create volume discounts table and complete ui piece ([#1272](https://github.com/provusinc/quoting/issues/1272)) ([6c42380](https://github.com/provusinc/quoting/commit/6c42380296d599f3b1d685538792460217f2da7d))
- **psq-4831:** rename dtos and creat mock data plus api ([#1271](https://github.com/provusinc/quoting/issues/1271)) ([d70a0a5](https://github.com/provusinc/quoting/commit/d70a0a5fe4d5f33acee360986fc69191b85b0d3b))
- **psq-4831:** volume discount summary API with mock data for test usage ([#1257](https://github.com/provusinc/quoting/issues/1257)) ([9ce9466](https://github.com/provusinc/quoting/commit/9ce9466b4d82e74494b77fd50341c34d11edfaaf))
- **psq-4837:** add resource dialog is showing products and service products ([#1251](https://github.com/provusinc/quoting/issues/1251)) ([16e9ee1](https://github.com/provusinc/quoting/commit/16e9ee19c64af8c991dfcdc70b3248cc1f841f6c))
- **psq-4837:** add resource dialog is showing products and service products ([#1251](https://github.com/provusinc/quoting/issues/1251)) ([ef4dcd7](https://github.com/provusinc/quoting/commit/ef4dcd7d48528774097e578469b3431ebc7652b1))
- **psq-4861:** location discount object creation ([#1249](https://github.com/provusinc/quoting/issues/1249)) ([5fe8806](https://github.com/provusinc/quoting/commit/5fe88067330161e38ab77f0825e5451f59c4c803))
- **psq-4862:** location discount review dialog ui ([#1280](https://github.com/provusinc/quoting/issues/1280)) ([7eb0079](https://github.com/provusinc/quoting/commit/7eb0079edae46956612da5153953fd375b1323b7))
- **psq-4863:** added view location discounts menu ([#1262](https://github.com/provusinc/quoting/issues/1262)) ([4246c8a](https://github.com/provusinc/quoting/commit/4246c8a32e0a6d8db5795c3afe3e5001c201a086))
- **psq-4866:** api implementation for location discount review dialog ([#1269](https://github.com/provusinc/quoting/issues/1269)) ([c7893e2](https://github.com/provusinc/quoting/commit/c7893e2149fc966508196d5e68a7598beed27c18))
- **psq-4958:** retrieve adjustment volume discount summaries ([#1273](https://github.com/provusinc/quoting/issues/1273)) ([2fb17b2](https://github.com/provusinc/quoting/commit/2fb17b2fc51c75695d0aa681bd9139b979b21d64))
- release ([#1228](https://github.com/provusinc/quoting/issues/1228)) ([9c6afdc](https://github.com/provusinc/quoting/commit/9c6afdc21391c173d014d7e752aede386e46a9ba)), closes [#1226](https://github.com/provusinc/quoting/issues/1226) [#1227](https://github.com/provusinc/quoting/issues/1227) [#1227](https://github.com/provusinc/quoting/issues/1227) [#1226](https://github.com/provusinc/quoting/issues/1226)
- the first version cannot have an ancestor ([d64b336](https://github.com/provusinc/quoting/commit/d64b336a7f15bb68fb4361b8b3143be365e40906))
- the first version cannot have an ancestor ([34f03d1](https://github.com/provusinc/quoting/commit/34f03d18340744af5b382d7c842661dc780d8fc0))
- trigger build ([41d04f5](https://github.com/provusinc/quoting/commit/41d04f5679c627b62ac016ea95e76cd2934d9694))
- **trigger build:** cleanup project json ([92f6dfc](https://github.com/provusinc/quoting/commit/92f6dfc007bdb0ac1135986ba6cd92a2ad3b8fd0))
- **trigger build:** revert label change from protected false -> protected true ([8ed69fc](https://github.com/provusinc/quoting/commit/8ed69fca67eb97229d3cf50485a61ea30e691945))
- **volume discount summary:** conditionally show dialog based on feature flag ([#1265](https://github.com/provusinc/quoting/issues/1265)) ([9f4d359](https://github.com/provusinc/quoting/commit/9f4d35910c45eefd09ca1a809698c3cca7d1b954))
- **volume discoutns summary:** added feature flag ([#1263](https://github.com/provusinc/quoting/issues/1263)) ([f03e783](https://github.com/provusinc/quoting/commit/f03e78342f1da55885f8f07cefcda24947ff41dd))

### Bug Fixes

- cache quote item named ranges ([#1304](https://github.com/provusinc/quoting/issues/1304)) ([6e6090a](https://github.com/provusinc/quoting/commit/6e6090a08bec805b3884af05b77e6bbade0f0db3))
- package.json & package-lock.json to reduce vulnerabilities ([#1237](https://github.com/provusinc/quoting/issues/1237)) ([294239c](https://github.com/provusinc/quoting/commit/294239ca7642ba62fec0d2d44b370ddd72eb5324))
- **psq-4504:** fix to suppress error message when service product is empty ([#1246](https://github.com/provusinc/quoting/issues/1246)) ([df35691](https://github.com/provusinc/quoting/commit/df35691a0cc848dfdf2351986598afd9c7aa6b19))
- **psq-4657:** period group volume discounts ([#1244](https://github.com/provusinc/quoting/issues/1244)) ([facec34](https://github.com/provusinc/quoting/commit/facec340302001765396af9038ce91d180b8f59a))
- **psq-4664:** fix cola rates pass through column ([#1270](https://github.com/provusinc/quoting/issues/1270)) ([1a71850](https://github.com/provusinc/quoting/commit/1a71850230f74cc85ac847f6c4b43d13f8ce4317))
- **psq-4704:** only require total by if valid tier exists for volume discount ([#1235](https://github.com/provusinc/quoting/issues/1235)) ([edfd9c7](https://github.com/provusinc/quoting/commit/edfd9c7fca5052a0d501c9e0597aa3a452d6c7a8))
- **psq-4751:** changes to overlaping header alignments ([#1238](https://github.com/provusinc/quoting/issues/1238)) ([3de8600](https://github.com/provusinc/quoting/commit/3de860041224f9a5364f8db7e9c86c525fb378d5))
- **psq-4756:** cloned task parameter values ([#1258](https://github.com/provusinc/quoting/issues/1258)) ([4235f83](https://github.com/provusinc/quoting/commit/4235f83c33f620cca3eb60754d7ff6f703efa67f))
- **psq-4759:** cloning scope parameter value of scope parameter which associated with estimate template, activity group and activity ([#1240](https://github.com/provusinc/quoting/issues/1240)) ([8d6a36e](https://github.com/provusinc/quoting/commit/8d6a36ec86bc20e3a5797917f385d39b377245ef))
- **psq-4808:** changes to service recommendation when product is not specified with estimate ([#1243](https://github.com/provusinc/quoting/issues/1243)) ([c63b948](https://github.com/provusinc/quoting/commit/c63b94895d8c678398c30c8199c306283a6b5913))
- **psq-4808:** changes to service recommendation when product is not specified with estimate ([#1243](https://github.com/provusinc/quoting/issues/1243)) ([374c6fb](https://github.com/provusinc/quoting/commit/374c6fb02b403dc876be6c38296d3f5c76f97daf))
- **psq-4903:** skip creation of totals records when creating a derived from quote ([12c9385](https://github.com/provusinc/quoting/commit/12c93857851ddae8711cbcd97acf4e178e839833))
- **psq-4903:** updated to clone only total named ranges on quote cloning ([#1311](https://github.com/provusinc/quoting/issues/1311)) ([5477a87](https://github.com/provusinc/quoting/commit/5477a877f8f78cbe517c2981821c2b6147350f85))
- **psq-4907:** fix to add quote to opportunity lines when made primary ([#1275](https://github.com/provusinc/quoting/issues/1275)) ([0569bba](https://github.com/provusinc/quoting/commit/0569bba694466ba633815862671c2b965436b525))
- **psq-4913:** adjust cola rates dialog to use add remove table ([#1279](https://github.com/provusinc/quoting/issues/1279)) ([9243870](https://github.com/provusinc/quoting/commit/924387035420d8d0158528ede09fd6ae66ac01dd))
- **psq-4930:** location discount dropdowns ([#1268](https://github.com/provusinc/quoting/issues/1268)) ([61f2beb](https://github.com/provusinc/quoting/commit/61f2beb245335e7075f0b676e4e8a31da5ef461b))
- **psq-4939:** nonbillable item populate grandtotal ([83f8e45](https://github.com/provusinc/quoting/commit/83f8e45283921ab7f8c5f05596aedc267135f583))
- **psq-4946:** changes to add correct service through show service Recommendations ([#1274](https://github.com/provusinc/quoting/issues/1274)) ([dcb07a1](https://github.com/provusinc/quoting/commit/dcb07a12b55c27fa4375297a31eab556137057f4))
- **psq-4958:** add category value to volume discount summary dto ([#1285](https://github.com/provusinc/quoting/issues/1285)) ([bbf5d09](https://github.com/provusinc/quoting/commit/bbf5d09ed2d59e4612d5ecf1d7763b71e3fc057e))
- **psq-4965:** sum was using rev and not cost ([5b8eddc](https://github.com/provusinc/quoting/commit/5b8eddc59eabd8c7ef3ced3bcb05b7bdeeae25c2))
- **psq-4976:** underline collaboration quote anchor link ([#1317](https://github.com/provusinc/quoting/issues/1317)) ([f87a059](https://github.com/provusinc/quoting/commit/f87a05938798d30b46532ca6e99dfeb8785fc90c))
- **psq-4977:** resolved previous merge conflict ([#1288](https://github.com/provusinc/quoting/issues/1288)) ([bac930e](https://github.com/provusinc/quoting/commit/bac930e941476cffc9f1e847a7fb65540630615a))
- **psq-4988:** resolve error pop up when saving volume discounts ([#1301](https://github.com/provusinc/quoting/issues/1301)) ([a8276db](https://github.com/provusinc/quoting/commit/a8276db28ddcecb00d8baff1c882d0f8c59a7973))
- **psq-4999, psq-4983, psq-4997:** various volume discount fixes ([#1303](https://github.com/provusinc/quoting/issues/1303)) ([4b9a589](https://github.com/provusinc/quoting/commit/4b9a589cda969957ed4a17545172fdbfc5549f59))
- **psq-5034:** data in the totals row is blank, tier rounding, sorting ([#1316](https://github.com/provusinc/quoting/issues/1316)) ([dc7b6d2](https://github.com/provusinc/quoting/commit/dc7b6d2493ad3c4e4fd5a8978696f06fe257f740))
- **psq-5042:** adjusted base amount and base extended amount mismatch ([#1314](https://github.com/provusinc/quoting/issues/1314)) ([022c09e](https://github.com/provusinc/quoting/commit/022c09e310717c152b2250ab317eb61a20e37822))
- **psq-5044:** allow save call to delete location discounts ([#1318](https://github.com/provusinc/quoting/issues/1318)) ([c6be68e](https://github.com/provusinc/quoting/commit/c6be68edba993f15dd21c01fa22d77e233d5b8ba))
- **psq-5049:** handles if there is no matching location discount ([#1313](https://github.com/provusinc/quoting/issues/1313)) ([875988f](https://github.com/provusinc/quoting/commit/875988f5f68fbf12034d37b80a010d27d82a2a0a))
- rectify failed tests introduced in pr [#1277](https://github.com/provusinc/quoting/issues/1277) ([62887a4](https://github.com/provusinc/quoting/commit/62887a44d6b57750139d9d854d9d085d03aeee36))
- rectify failed tests introduced in pr [#1277](https://github.com/provusinc/quoting/issues/1277) ([cc5e6a0](https://github.com/provusinc/quoting/commit/cc5e6a00896ca5dc3a955fa821ae4c3cdb9e656d))
- rectify failed tests introduced in pr [#1277](https://github.com/provusinc/quoting/issues/1277) ([268613e](https://github.com/provusinc/quoting/commit/268613e13829ebe341b65539fb860e76d7dff391))
- rectify failed tests introduced in pr [#1277](https://github.com/provusinc/quoting/issues/1277) ([b940b76](https://github.com/provusinc/quoting/commit/b940b76b298c09759e7b3ab491a00531d25f891c))
- rectify failed tests introduced in pr [#1277](https://github.com/provusinc/quoting/issues/1277) ([94cd81d](https://github.com/provusinc/quoting/commit/94cd81df6fc4694af5b404d076964e50d6ecb857))
- rectify failed tests introduced in pr [#1277](https://github.com/provusinc/quoting/issues/1277) ([a36f996](https://github.com/provusinc/quoting/commit/a36f996ff4f7cb3da76f4a350fe9b7a9ba74055e))
- rectify failed tests introduced in pr [#1277](https://github.com/provusinc/quoting/issues/1277) ([7517361](https://github.com/provusinc/quoting/commit/7517361794b900487fe6e6f9f161f2375d67c194))
- **submit for approvals:** added error handling for incomplete approval setups ([#1239](https://github.com/provusinc/quoting/issues/1239)) ([ffb2912](https://github.com/provusinc/quoting/commit/ffb2912c573c903b95ea78116291857d7ef33f3b))
- volume discount summary heading ([#1293](https://github.com/provusinc/quoting/issues/1293)) ([7bdf23e](https://github.com/provusinc/quoting/commit/7bdf23edc7f3789fc631e35b8575b8a4c8bcce5d))

### Reverts

- Revert "chore: release 08-01 sprint to preprod (#1308)" (#1309) ([a270294](https://github.com/provusinc/quoting/commit/a270294dd151799a95cdb31051aa33122b05bcdc)), closes [#1308](https://github.com/provusinc/quoting/issues/1308) [#1309](https://github.com/provusinc/quoting/issues/1309)

## [2.34.0-next.41](https://github.com/provusinc/quoting/compare/v2.34.0-next.40...v2.34.0-next.41) (2022-08-01)

### Bug Fixes

- **psq-5034:** data in the totals row is blank, tier rounding, sorting ([#1316](https://github.com/provusinc/quoting/issues/1316)) ([dc7b6d2](https://github.com/provusinc/quoting/commit/dc7b6d2493ad3c4e4fd5a8978696f06fe257f740))

## [2.34.0-next.40](https://github.com/provusinc/quoting/compare/v2.34.0-next.39...v2.34.0-next.40) (2022-08-01)

### Features

- **custom labels:** cleanup custom labels ([#1315](https://github.com/provusinc/quoting/issues/1315)) ([dd14f3e](https://github.com/provusinc/quoting/commit/dd14f3edc3f9e6bf9c84d9b7d755ba199acfda61))

## [2.34.0-next.39](https://github.com/provusinc/quoting/compare/v2.34.0-next.38...v2.34.0-next.39) (2022-08-01)

### Bug Fixes

- **psq-4903:** updated to clone only total named ranges on quote cloning ([#1311](https://github.com/provusinc/quoting/issues/1311)) ([5477a87](https://github.com/provusinc/quoting/commit/5477a877f8f78cbe517c2981821c2b6147350f85))
- **psq-5042:** adjusted base amount and base extended amount mismatch ([#1314](https://github.com/provusinc/quoting/issues/1314)) ([022c09e](https://github.com/provusinc/quoting/commit/022c09e310717c152b2250ab317eb61a20e37822))

## [2.34.0-next.38](https://github.com/provusinc/quoting/compare/v2.34.0-next.37...v2.34.0-next.38) (2022-08-01)

### Features

- **periods alignment:** remove unused period alignments ([eeb8fb7](https://github.com/provusinc/quoting/commit/eeb8fb76818c23dbe61a706beb1744e43216f979))

### Bug Fixes

- **psq-5049:** handles if there is no matching location discount ([#1313](https://github.com/provusinc/quoting/issues/1313)) ([875988f](https://github.com/provusinc/quoting/commit/875988f5f68fbf12034d37b80a010d27d82a2a0a))

## [2.34.0-next.37](https://github.com/provusinc/quoting/compare/v2.34.0-next.36...v2.34.0-next.37) (2022-08-01)

### Bug Fixes

- **psq-4939:** nonbillable item populate grandtotal ([83f8e45](https://github.com/provusinc/quoting/commit/83f8e45283921ab7f8c5f05596aedc267135f583))

### Reverts

- Revert "chore: release 08-01 sprint to preprod (#1308)" (#1309) ([a270294](https://github.com/provusinc/quoting/commit/a270294dd151799a95cdb31051aa33122b05bcdc)), closes [#1308](https://github.com/provusinc/quoting/issues/1308) [#1309](https://github.com/provusinc/quoting/issues/1309)

## [2.34.0-next.36](https://github.com/provusinc/quoting/compare/v2.34.0-next.35...v2.34.0-next.36) (2022-07-30)

### Features

- **psq-4818:** add location to named ranges and properly retrieve from new named ranges ([#1306](https://github.com/provusinc/quoting/issues/1306)) ([4372cb6](https://github.com/provusinc/quoting/commit/4372cb6eb9bfe4713ace1a58991322301fed3cdb))

### Bug Fixes

- cache quote item named ranges ([#1304](https://github.com/provusinc/quoting/issues/1304)) ([6e6090a](https://github.com/provusinc/quoting/commit/6e6090a08bec805b3884af05b77e6bbade0f0db3))

## [2.34.0-next.35](https://github.com/provusinc/quoting/compare/v2.34.0-next.34...v2.34.0-next.35) (2022-07-30)

### Features

- **psq-4818:** updated add/remove adjustments for location discounts ([#1302](https://github.com/provusinc/quoting/issues/1302)) ([c5fda5b](https://github.com/provusinc/quoting/commit/c5fda5b35ba14743d3ba69f0f01a35a8074993ac))

### Bug Fixes

- **psq-4988:** resolve error pop up when saving volume discounts ([#1301](https://github.com/provusinc/quoting/issues/1301)) ([a8276db](https://github.com/provusinc/quoting/commit/a8276db28ddcecb00d8baff1c882d0f8c59a7973))
- **psq-4999, psq-4983, psq-4997:** various volume discount fixes ([#1303](https://github.com/provusinc/quoting/issues/1303)) ([4b9a589](https://github.com/provusinc/quoting/commit/4b9a589cda969957ed4a17545172fdbfc5549f59))

## [2.34.0-next.34](https://github.com/provusinc/quoting/compare/v2.34.0-next.33...v2.34.0-next.34) (2022-07-29)

### Features

- **psq-4818:** Calculate and Apply Location Discount Adjustment ([#1299](https://github.com/provusinc/quoting/issues/1299)) ([a990e61](https://github.com/provusinc/quoting/commit/a990e61e6a8b356db9c0b3dac2003b4537214856)), closes [#1277](https://github.com/provusinc/quoting/issues/1277)

## [2.34.0-next.33](https://github.com/provusinc/quoting/compare/v2.34.0-next.32...v2.34.0-next.33) (2022-07-29)

### Features

- **psq-4154:** create totals rows, minimum modal height ([#1298](https://github.com/provusinc/quoting/issues/1298)) ([b57901e](https://github.com/provusinc/quoting/commit/b57901ec247f552673f8baa84c0787194684e324))
- **psq-4179:** labor revenue calculation, period/group name fixes ([#1297](https://github.com/provusinc/quoting/issues/1297)) ([ece3d07](https://github.com/provusinc/quoting/commit/ece3d0772c427e31f7701d686f533d4945c4b443))

## [2.34.0-next.32](https://github.com/provusinc/quoting/compare/v2.34.0-next.31...v2.34.0-next.32) (2022-07-28)

### Features

- **psq-4657:** calculate discount correctly for quote and period tota… ([#1277](https://github.com/provusinc/quoting/issues/1277)) ([6516d92](https://github.com/provusinc/quoting/commit/6516d922ce752314ae0c6b947050dbdf767b6a1e))

### Bug Fixes

- rectify failed tests introduced in pr [#1277](https://github.com/provusinc/quoting/issues/1277) ([62887a4](https://github.com/provusinc/quoting/commit/62887a44d6b57750139d9d854d9d085d03aeee36))
- rectify failed tests introduced in pr [#1277](https://github.com/provusinc/quoting/issues/1277) ([cc5e6a0](https://github.com/provusinc/quoting/commit/cc5e6a00896ca5dc3a955fa821ae4c3cdb9e656d))
- rectify failed tests introduced in pr [#1277](https://github.com/provusinc/quoting/issues/1277) ([268613e](https://github.com/provusinc/quoting/commit/268613e13829ebe341b65539fb860e76d7dff391))
- rectify failed tests introduced in pr [#1277](https://github.com/provusinc/quoting/issues/1277) ([b940b76](https://github.com/provusinc/quoting/commit/b940b76b298c09759e7b3ab491a00531d25f891c))
- rectify failed tests introduced in pr [#1277](https://github.com/provusinc/quoting/issues/1277) ([94cd81d](https://github.com/provusinc/quoting/commit/94cd81df6fc4694af5b404d076964e50d6ecb857))
- rectify failed tests introduced in pr [#1277](https://github.com/provusinc/quoting/issues/1277) ([a36f996](https://github.com/provusinc/quoting/commit/a36f996ff4f7cb3da76f4a350fe9b7a9ba74055e))
- rectify failed tests introduced in pr [#1277](https://github.com/provusinc/quoting/issues/1277) ([7517361](https://github.com/provusinc/quoting/commit/7517361794b900487fe6e6f9f161f2375d67c194))

## [2.34.0-next.31](https://github.com/provusinc/quoting/compare/v2.34.0-next.30...v2.34.0-next.31) (2022-07-28)

### Bug Fixes

- volume discount summary heading ([#1293](https://github.com/provusinc/quoting/issues/1293)) ([7bdf23e](https://github.com/provusinc/quoting/commit/7bdf23edc7f3789fc631e35b8575b8a4c8bcce5d))

## [2.34.0-next.30](https://github.com/provusinc/quoting/compare/v2.34.0-next.29...v2.34.0-next.30) (2022-07-28)

### Features

- **psq-4154:** fix discount percentage and discount amount display ([#1289](https://github.com/provusinc/quoting/issues/1289)) ([ff2bf8c](https://github.com/provusinc/quoting/commit/ff2bf8c753034e355af02eee26ab90a296b89603))
- **psq-4179:** ability to create labor revenue volume discount ([#1292](https://github.com/provusinc/quoting/issues/1292)) ([172e005](https://github.com/provusinc/quoting/commit/172e005f56aef5bf8d566a61f525a5ad7879069a))

## [2.34.0-next.29](https://github.com/provusinc/quoting/compare/v2.34.0-next.28...v2.34.0-next.29) (2022-07-27)

### Features

- **psq-4154:** fix min/max revenue labels ([#1290](https://github.com/provusinc/quoting/issues/1290)) ([b9495e8](https://github.com/provusinc/quoting/commit/b9495e80a1b5a3e4f6ff750492d747b56fe8349e))

## [2.34.0-next.28](https://github.com/provusinc/quoting/compare/v2.34.0-next.27...v2.34.0-next.28) (2022-07-27)

### Bug Fixes

- **psq-4977:** resolved previous merge conflict ([#1288](https://github.com/provusinc/quoting/issues/1288)) ([bac930e](https://github.com/provusinc/quoting/commit/bac930e941476cffc9f1e847a7fb65540630615a))

## [2.34.0-next.27](https://github.com/provusinc/quoting/compare/v2.34.0-next.26...v2.34.0-next.27) (2022-07-27)

### Bug Fixes

- **psq-4958:** add category value to volume discount summary dto ([#1285](https://github.com/provusinc/quoting/issues/1285)) ([bbf5d09](https://github.com/provusinc/quoting/commit/bbf5d09ed2d59e4612d5ecf1d7763b71e3fc057e))

## [2.34.0-next.26](https://github.com/provusinc/quoting/compare/v2.34.0-next.25...v2.34.0-next.26) (2022-07-27)

### Features

- **location discount:** refactored locationleveldiscount into just locationdiscount ([#1284](https://github.com/provusinc/quoting/issues/1284)) ([2d03b02](https://github.com/provusinc/quoting/commit/2d03b02f23f61e941b80f38fc39b5667b3ab0c72))
- **psq-4866:** api implementation for location discount review dialog ([#1269](https://github.com/provusinc/quoting/issues/1269)) ([c7893e2](https://github.com/provusinc/quoting/commit/c7893e2149fc966508196d5e68a7598beed27c18))

### Bug Fixes

- **psq-4907:** fix to add quote to opportunity lines when made primary ([#1275](https://github.com/provusinc/quoting/issues/1275)) ([0569bba](https://github.com/provusinc/quoting/commit/0569bba694466ba633815862671c2b965436b525))

## [2.34.0-next.25](https://github.com/provusinc/quoting/compare/v2.34.0-next.24...v2.34.0-next.25) (2022-07-27)

### Bug Fixes

- **psq-4903:** skip creation of totals records when creating a derived from quote ([12c9385](https://github.com/provusinc/quoting/commit/12c93857851ddae8711cbcd97acf4e178e839833))

## [2.34.0-next.24](https://github.com/provusinc/quoting/compare/v2.34.0-next.23...v2.34.0-next.24) (2022-07-26)

### Features

- **psq-4837:** add resource dialog is showing products and service products ([#1251](https://github.com/provusinc/quoting/issues/1251)) ([16e9ee1](https://github.com/provusinc/quoting/commit/16e9ee19c64af8c991dfcdc70b3248cc1f841f6c))
- the first version cannot have an ancestor ([d64b336](https://github.com/provusinc/quoting/commit/d64b336a7f15bb68fb4361b8b3143be365e40906))
- the first version cannot have an ancestor ([34f03d1](https://github.com/provusinc/quoting/commit/34f03d18340744af5b382d7c842661dc780d8fc0))

### Bug Fixes

- **psq-4808:** changes to service recommendation when product is not specified with estimate ([#1243](https://github.com/provusinc/quoting/issues/1243)) ([c63b948](https://github.com/provusinc/quoting/commit/c63b94895d8c678398c30c8199c306283a6b5913))
- **psq-4965:** sum was using rev and not cost ([5b8eddc](https://github.com/provusinc/quoting/commit/5b8eddc59eabd8c7ef3ced3bcb05b7bdeeae25c2))

## [2.34.0-next.23](https://github.com/provusinc/quoting/compare/v2.34.0-next.22...v2.34.0-next.23) (2022-07-26)

### Features

- **psq-4862:** location discount review dialog ui ([#1280](https://github.com/provusinc/quoting/issues/1280)) ([7eb0079](https://github.com/provusinc/quoting/commit/7eb0079edae46956612da5153953fd375b1323b7))

## [2.34.0-next.22](https://github.com/provusinc/quoting/compare/v2.34.0-next.21...v2.34.0-next.22) (2022-07-26)

### Bug Fixes

- **psq-4913:** adjust cola rates dialog to use add remove table ([#1279](https://github.com/provusinc/quoting/issues/1279)) ([9243870](https://github.com/provusinc/quoting/commit/924387035420d8d0158528ede09fd6ae66ac01dd))

## [2.34.0-next.21](https://github.com/provusinc/quoting/compare/v2.34.0-next.20...v2.34.0-next.21) (2022-07-26)

### Features

- **psq-4830:** create volume discounts table and complete ui piece ([#1272](https://github.com/provusinc/quoting/issues/1272)) ([6c42380](https://github.com/provusinc/quoting/commit/6c42380296d599f3b1d685538792460217f2da7d))
- **trigger build:** revert label change from protected false -> protected true ([8ed69fc](https://github.com/provusinc/quoting/commit/8ed69fca67eb97229d3cf50485a61ea30e691945))

### Bug Fixes

- **psq-4946:** changes to add correct service through show service Recommendations ([#1274](https://github.com/provusinc/quoting/issues/1274)) ([dcb07a1](https://github.com/provusinc/quoting/commit/dcb07a12b55c27fa4375297a31eab556137057f4))

## [2.34.0-next.20](https://github.com/provusinc/quoting/compare/v2.34.0-next.19...v2.34.0-next.20) (2022-07-26)

### Features

- **psq-4958:** retrieve adjustment volume discount summaries ([#1273](https://github.com/provusinc/quoting/issues/1273)) ([2fb17b2](https://github.com/provusinc/quoting/commit/2fb17b2fc51c75695d0aa681bd9139b979b21d64))

## [2.34.0-next.19](https://github.com/provusinc/quoting/compare/v2.34.0-next.18...v2.34.0-next.19) (2022-07-25)

### Features

- **psq-4831:** rename dtos and creat mock data plus api ([#1271](https://github.com/provusinc/quoting/issues/1271)) ([d70a0a5](https://github.com/provusinc/quoting/commit/d70a0a5fe4d5f33acee360986fc69191b85b0d3b))

### Bug Fixes

- **psq-4664:** fix cola rates pass through column ([#1270](https://github.com/provusinc/quoting/issues/1270)) ([1a71850](https://github.com/provusinc/quoting/commit/1a71850230f74cc85ac847f6c4b43d13f8ce4317))

## [2.34.0-next.18](https://github.com/provusinc/quoting/compare/v2.34.0-next.17...v2.34.0-next.18) (2022-07-23)

### Bug Fixes

- **psq-4930:** location discount dropdowns ([#1268](https://github.com/provusinc/quoting/issues/1268)) ([61f2beb](https://github.com/provusinc/quoting/commit/61f2beb245335e7075f0b676e4e8a31da5ef461b))

## [2.34.0-next.17](https://github.com/provusinc/quoting/compare/v2.34.0-next.16...v2.34.0-next.17) (2022-07-23)

### Features

- **psq-4837:** add resource dialog is showing products and service products ([#1251](https://github.com/provusinc/quoting/issues/1251)) ([ef4dcd7](https://github.com/provusinc/quoting/commit/ef4dcd7d48528774097e578469b3431ebc7652b1))

### Bug Fixes

- **psq-4756:** cloned task parameter values ([#1258](https://github.com/provusinc/quoting/issues/1258)) ([4235f83](https://github.com/provusinc/quoting/commit/4235f83c33f620cca3eb60754d7ff6f703efa67f))

## [2.34.0-next.16](https://github.com/provusinc/quoting/compare/v2.34.0-next.15...v2.34.0-next.16) (2022-07-23)

### Features

- **psq-4817:** implement location discounts table ([#1266](https://github.com/provusinc/quoting/issues/1266)) ([7d186eb](https://github.com/provusinc/quoting/commit/7d186eba69febe5c424110328c089c035842f573))
- **psq-4827:** create adjustment volume discount object ([#1264](https://github.com/provusinc/quoting/issues/1264)) ([134bfe7](https://github.com/provusinc/quoting/commit/134bfe79b893c12af9290dd317dcf5c337071b52))
- **psq-4828:** create adjustment volume discount tier junction ([#1267](https://github.com/provusinc/quoting/issues/1267)) ([4980fbb](https://github.com/provusinc/quoting/commit/4980fbb4125ccaaf3aee2f2596e7c7c970ec5c29))
- **volume discount summary:** conditionally show dialog based on feature flag ([#1265](https://github.com/provusinc/quoting/issues/1265)) ([9f4d359](https://github.com/provusinc/quoting/commit/9f4d35910c45eefd09ca1a809698c3cca7d1b954))
- **volume discoutns summary:** added feature flag ([#1263](https://github.com/provusinc/quoting/issues/1263)) ([f03e783](https://github.com/provusinc/quoting/commit/f03e78342f1da55885f8f07cefcda24947ff41dd))

## [2.34.0-next.15](https://github.com/provusinc/quoting/compare/v2.34.0-next.14...v2.34.0-next.15) (2022-07-22)

### Features

- **psq-4863:** added view location discounts menu ([#1262](https://github.com/provusinc/quoting/issues/1262)) ([4246c8a](https://github.com/provusinc/quoting/commit/4246c8a32e0a6d8db5795c3afe3e5001c201a086))

## [2.34.0-next.14](https://github.com/provusinc/quoting/compare/v2.34.0-next.13...v2.34.0-next.14) (2022-07-22)

### Features

- **location discount review:** location discount review dtos + stub … ([#1260](https://github.com/provusinc/quoting/issues/1260)) ([e6a91be](https://github.com/provusinc/quoting/commit/e6a91be5303a43bfaa8dfd26f44ae2b38bb305df))

## [2.34.0-next.13](https://github.com/provusinc/quoting/compare/v2.34.0-next.12...v2.34.0-next.13) (2022-07-22)

### Features

- **ps-3399:** support total estimated amount in service recommendations ([#1255](https://github.com/provusinc/quoting/issues/1255)) ([3c6c177](https://github.com/provusinc/quoting/commit/3c6c1770d1b97db488c438c476fb2791950e0ee9))
- **psq-4154:** add review volume discount menu item to delta menu for cola rate dialog ([#1256](https://github.com/provusinc/quoting/issues/1256)) ([0569f83](https://github.com/provusinc/quoting/commit/0569f83f1b29203ba8f55cd74668e64de620b997))
- **psq-4824:** refactor existing global cola admin table ([#1253](https://github.com/provusinc/quoting/issues/1253)) ([869a17c](https://github.com/provusinc/quoting/commit/869a17c996bb2e05df97e1d584ee93a3fc69243d))
- **psq-4831:** volume discount summary API with mock data for test usage ([#1257](https://github.com/provusinc/quoting/issues/1257)) ([9ce9466](https://github.com/provusinc/quoting/commit/9ce9466b4d82e74494b77fd50341c34d11edfaaf))

## [2.34.0-next.12](https://github.com/provusinc/quoting/compare/v2.34.0-next.11...v2.34.0-next.12) (2022-07-21)

### Features

- **location level discounts:** added transformation methods to dto and get retrieve service methods ([#1250](https://github.com/provusinc/quoting/issues/1250)) ([40bea6a](https://github.com/provusinc/quoting/commit/40bea6a6b5973f9461a5b641f9ed9392c1da7cb1))
- **psq-4861:** location discount object creation ([#1249](https://github.com/provusinc/quoting/issues/1249)) ([5fe8806](https://github.com/provusinc/quoting/commit/5fe88067330161e38ab77f0825e5451f59c4c803))

## [2.34.0-next.11](https://github.com/provusinc/quoting/compare/v2.34.0-next.10...v2.34.0-next.11) (2022-07-20)

### Features

- **location level discount:** created initial dtos and stubbed api functions for mock data ([#1247](https://github.com/provusinc/quoting/issues/1247)) ([a6f0ad7](https://github.com/provusinc/quoting/commit/a6f0ad7207a4d1c8e82befca00e708f3a69a65ee))

## [2.34.0-next.10](https://github.com/provusinc/quoting/compare/v2.34.0-next.9...v2.34.0-next.10) (2022-07-20)

### Bug Fixes

- **psq-4504:** fix to suppress error message when service product is empty ([#1246](https://github.com/provusinc/quoting/issues/1246)) ([df35691](https://github.com/provusinc/quoting/commit/df35691a0cc848dfdf2351986598afd9c7aa6b19))

## [2.34.0-next.9](https://github.com/provusinc/quoting/compare/v2.34.0-next.8...v2.34.0-next.9) (2022-07-20)

### Features

- **psq-4816:** added location discount tab placeholder ([#1245](https://github.com/provusinc/quoting/issues/1245)) ([1cf2876](https://github.com/provusinc/quoting/commit/1cf28760c3937119a6eaff962e500788326945a7))

### Bug Fixes

- **psq-4808:** changes to service recommendation when product is not specified with estimate ([#1243](https://github.com/provusinc/quoting/issues/1243)) ([374c6fb](https://github.com/provusinc/quoting/commit/374c6fb02b403dc876be6c38296d3f5c76f97daf))

## [2.34.0-next.8](https://github.com/provusinc/quoting/compare/v2.34.0-next.7...v2.34.0-next.8) (2022-07-19)

### Bug Fixes

- **psq-4657:** period group volume discounts ([#1244](https://github.com/provusinc/quoting/issues/1244)) ([facec34](https://github.com/provusinc/quoting/commit/facec340302001765396af9038ce91d180b8f59a))

## [2.34.0-next.7](https://github.com/provusinc/quoting/compare/v2.34.0-next.6...v2.34.0-next.7) (2022-07-19)

### Bug Fixes

- **psq-4759:** cloning scope parameter value of scope parameter which associated with estimate template, activity group and activity ([#1240](https://github.com/provusinc/quoting/issues/1240)) ([8d6a36e](https://github.com/provusinc/quoting/commit/8d6a36ec86bc20e3a5797917f385d39b377245ef))

## [2.34.0-next.6](https://github.com/provusinc/quoting/compare/v2.34.0-next.5...v2.34.0-next.6) (2022-07-18)

### Bug Fixes

- **psq-4704:** only require total by if valid tier exists for volume discount ([#1235](https://github.com/provusinc/quoting/issues/1235)) ([edfd9c7](https://github.com/provusinc/quoting/commit/edfd9c7fca5052a0d501c9e0597aa3a452d6c7a8))

## [2.34.0-next.5](https://github.com/provusinc/quoting/compare/v2.34.0-next.4...v2.34.0-next.5) (2022-07-18)

### Features

- **named range:** add unbilled labor and add on named ranges ([919fb02](https://github.com/provusinc/quoting/commit/919fb024b6c87c46bfa1d8ed8cb848b37761ce66))
- release ([#1228](https://github.com/provusinc/quoting/issues/1228)) ([9c6afdc](https://github.com/provusinc/quoting/commit/9c6afdc21391c173d014d7e752aede386e46a9ba)), closes [#1226](https://github.com/provusinc/quoting/issues/1226) [#1227](https://github.com/provusinc/quoting/issues/1227) [#1227](https://github.com/provusinc/quoting/issues/1227) [#1226](https://github.com/provusinc/quoting/issues/1226)
- trigger build ([41d04f5](https://github.com/provusinc/quoting/commit/41d04f5679c627b62ac016ea95e76cd2934d9694))
- **trigger build:** cleanup project json ([92f6dfc](https://github.com/provusinc/quoting/commit/92f6dfc007bdb0ac1135986ba6cd92a2ad3b8fd0))

### Bug Fixes

- package.json & package-lock.json to reduce vulnerabilities ([#1237](https://github.com/provusinc/quoting/issues/1237)) ([294239c](https://github.com/provusinc/quoting/commit/294239ca7642ba62fec0d2d44b370ddd72eb5324))
- **psq-4751:** changes to overlaping header alignments ([#1238](https://github.com/provusinc/quoting/issues/1238)) ([3de8600](https://github.com/provusinc/quoting/commit/3de860041224f9a5364f8db7e9c86c525fb378d5))
- **submit for approvals:** added error handling for incomplete approval setups ([#1239](https://github.com/provusinc/quoting/issues/1239)) ([ffb2912](https://github.com/provusinc/quoting/commit/ffb2912c573c903b95ea78116291857d7ef33f3b))

## [2.34.0-next.5](https://github.com/provusinc/quoting/compare/v2.34.0-next.4...v2.34.0-next.5) (2022-07-17)

### Features

- **named range:** add unbilled labor and add on named ranges ([919fb02](https://github.com/provusinc/quoting/commit/919fb024b6c87c46bfa1d8ed8cb848b37761ce66))
- release ([#1228](https://github.com/provusinc/quoting/issues/1228)) ([9c6afdc](https://github.com/provusinc/quoting/commit/9c6afdc21391c173d014d7e752aede386e46a9ba)), closes [#1226](https://github.com/provusinc/quoting/issues/1226) [#1227](https://github.com/provusinc/quoting/issues/1227) [#1227](https://github.com/provusinc/quoting/issues/1227) [#1226](https://github.com/provusinc/quoting/issues/1226)
- trigger build ([41d04f5](https://github.com/provusinc/quoting/commit/41d04f5679c627b62ac016ea95e76cd2934d9694))
- **trigger build:** cleanup project json ([92f6dfc](https://github.com/provusinc/quoting/commit/92f6dfc007bdb0ac1135986ba6cd92a2ad3b8fd0))

### Bug Fixes

- package.json & package-lock.json to reduce vulnerabilities ([#1237](https://github.com/provusinc/quoting/issues/1237)) ([294239c](https://github.com/provusinc/quoting/commit/294239ca7642ba62fec0d2d44b370ddd72eb5324))

## [2.35.0](https://github.com/provusinc/quoting/compare/v2.34.0...v2.35.0) (2022-07-17)

### Features

- **event footer:** allow button disabling via a hook to the button node ([#1234](https://github.com/provusinc/quoting/issues/1234)) ([ec1acea](https://github.com/provusinc/quoting/commit/ec1acea8ba41a3f949c8e9a8a44ca2522fd9171a))
- **named range:** add unbilled labor and add on named ranges ([0b3f538](https://github.com/provusinc/quoting/commit/0b3f5389022939213d4da7d7b6ed1ac5d33a14f7))
- **psq-4748:** show combobox on top of volume discount dialog ([#1227](https://github.com/provusinc/quoting/issues/1227)) ([65da0bf](https://github.com/provusinc/quoting/commit/65da0bfa779ae22ea19672e60fad3540e978aa23))

### Bug Fixes

- **cola rates:** resize cola rates dialog ([#1233](https://github.com/provusinc/quoting/issues/1233)) ([d71109b](https://github.com/provusinc/quoting/commit/d71109b899aec5c7a5a0329c52eef370a879c775))
- **psq-4394:** disable grid on click of collab commit ([#1236](https://github.com/provusinc/quoting/issues/1236)) ([00d61c0](https://github.com/provusinc/quoting/commit/00d61c04377194794092c33aa0a00013fbeccd3a))
- **psq-4504:** fix for opportunity lines not populated for service quote ([#1231](https://github.com/provusinc/quoting/issues/1231)) ([60b938b](https://github.com/provusinc/quoting/commit/60b938bb5f14ede96c6cb9d25fc230e35500c051))
- **psq-4703:** volume discount is removed on refresh ([#1226](https://github.com/provusinc/quoting/issues/1226)) ([58ced02](https://github.com/provusinc/quoting/commit/58ced028d623a25dc0ef4b699dffd035034010ab))
- **psq-4760:** reprice after cell shift ([#1232](https://github.com/provusinc/quoting/issues/1232)) ([515c139](https://github.com/provusinc/quoting/commit/515c139a3d081e62e321c47588d51e19308e4b0d))
- set name spec to avoid duplicate period named ranges ([3c3c069](https://github.com/provusinc/quoting/commit/3c3c069d3f5cbbd8e18d2d8187c6f24f44a8f037))
- upgrade @salesforce-ux/design-system from 2.18.0 to 2.18.1 ([#1230](https://github.com/provusinc/quoting/issues/1230)) ([39f09e2](https://github.com/provusinc/quoting/commit/39f09e263661669a6c5f5f33909d9a195eaaafc8))

## [2.34.0-next.4](https://github.com/provusinc/quoting/compare/v2.34.0-next.3...v2.34.0-next.4) (2022-07-16)

### Features

- **event footer:** allow button disabling via a hook to the button node ([#1234](https://github.com/provusinc/quoting/issues/1234)) ([ec1acea](https://github.com/provusinc/quoting/commit/ec1acea8ba41a3f949c8e9a8a44ca2522fd9171a))

### Bug Fixes

- **cola rates:** resize cola rates dialog ([#1233](https://github.com/provusinc/quoting/issues/1233)) ([d71109b](https://github.com/provusinc/quoting/commit/d71109b899aec5c7a5a0329c52eef370a879c775))
- **psq-4394:** disable grid on click of collab commit ([#1236](https://github.com/provusinc/quoting/issues/1236)) ([00d61c0](https://github.com/provusinc/quoting/commit/00d61c04377194794092c33aa0a00013fbeccd3a))
- **psq-4504:** fix for opportunity lines not populated for service quote ([#1231](https://github.com/provusinc/quoting/issues/1231)) ([60b938b](https://github.com/provusinc/quoting/commit/60b938bb5f14ede96c6cb9d25fc230e35500c051))
- **psq-4760:** reprice after cell shift ([#1232](https://github.com/provusinc/quoting/issues/1232)) ([515c139](https://github.com/provusinc/quoting/commit/515c139a3d081e62e321c47588d51e19308e4b0d))

## [2.34.0-next.3](https://github.com/provusinc/quoting/compare/v2.34.0-next.2...v2.34.0-next.3) (2022-07-14)

### Bug Fixes

- upgrade @salesforce-ux/design-system from 2.18.0 to 2.18.1 ([#1230](https://github.com/provusinc/quoting/issues/1230)) ([39f09e2](https://github.com/provusinc/quoting/commit/39f09e263661669a6c5f5f33909d9a195eaaafc8))

## [2.34.0-next.2](https://github.com/provusinc/quoting/compare/v2.34.0-next.1...v2.34.0-next.2) (2022-07-14)

### Bug Fixes

- set name spec to avoid duplicate period named ranges ([3c3c069](https://github.com/provusinc/quoting/commit/3c3c069d3f5cbbd8e18d2d8187c6f24f44a8f037))

## [2.34.0-next.1](https://github.com/provusinc/quoting/compare/v2.33.0...v2.34.0-next.1) (2022-07-14)

### Features

- **psq-4748:** show combobox on top of volume discount dialog ([#1227](https://github.com/provusinc/quoting/issues/1227)) ([65da0bf](https://github.com/provusinc/quoting/commit/65da0bfa779ae22ea19672e60fad3540e978aa23))

### Bug Fixes

- **psq-4703:** volume discount is removed on refresh ([#1226](https://github.com/provusinc/quoting/issues/1226)) ([58ced02](https://github.com/provusinc/quoting/commit/58ced028d623a25dc0ef4b699dffd035034010ab))

## [2.33.0](https://github.com/provusinc/quoting/compare/v2.32.3...v2.33.0) (2022-07-13)

### Features

- **3171:** ability to approve a quote in the quote compare page ([#1152](https://github.com/provusinc/quoting/issues/1152)) ([11f7590](https://github.com/provusinc/quoting/commit/11f7590e54c2ae87fdfc37ba9dad783b86164f75))
- **adjustment method picklist:** remove restricted picklist ([000dadf](https://github.com/provusinc/quoting/commit/000dadfa05d4553497022222027679a174725967))
- **approval email notification:** add primary quote ([95d464e](https://github.com/provusinc/quoting/commit/95d464ef977d33b74198f47356ad9834c65be9cb))
- **approval email notification:** add primary quote ([#1174](https://github.com/provusinc/quoting/issues/1174)) ([3473b51](https://github.com/provusinc/quoting/commit/3473b51b00bb38f749afbb90e33d3a5be109f934))
- **approval email:** add formulae for account and quote name lookups ([d1af285](https://github.com/provusinc/quoting/commit/d1af285087e522828e0a3a63728d3ee46397dc81))
- **collab:** show link to collab quote in section header ([#1211](https://github.com/provusinc/quoting/issues/1211)) ([d5edb67](https://github.com/provusinc/quoting/commit/d5edb67ae847a9509916b54243b27f6556a63e3c))
- **metadata api:** breakup the metadata api into individual classes ([a2bea4c](https://github.com/provusinc/quoting/commit/a2bea4c6af58577c0eb904f23c4cd8cfa373e855))
- post install script to add missing picklist values ([#1212](https://github.com/provusinc/quoting/issues/1212)) ([0450c8c](https://github.com/provusinc/quoting/commit/0450c8cde4139d5914b32a766ffb325af361d9c7))
- **psq-1504:** apex code, apex tests and supporting frontend code for volume discount API ([#1175](https://github.com/provusinc/quoting/issues/1175)) ([7cccf65](https://github.com/provusinc/quoting/commit/7cccf6538cb02c2917605efbe1c8a612791cd63a))
- **psq-1504:** code defect when opening volume discount dialog for first time on quote ([#1190](https://github.com/provusinc/quoting/issues/1190)) ([6d50016](https://github.com/provusinc/quoting/commit/6d5001623b93525855a04932a4f7d280b83a0caf))
- **psq-1504:** make volume discount dtos param named in ui code ([#1180](https://github.com/provusinc/quoting/issues/1180)) ([7839dce](https://github.com/provusinc/quoting/commit/7839dce478dd07c5eba3febf149f62a8918301b8))
- **psq-1504:** rename quote volume discount object ([#1166](https://github.com/provusinc/quoting/issues/1166)) ([7a2b571](https://github.com/provusinc/quoting/commit/7a2b571e5425b21259fb81146f89f7bc825eee86))
- **psq-1504:** user can edit volume discount fields and receive validation feedback ([#1156](https://github.com/provusinc/quoting/issues/1156)) ([57f30ce](https://github.com/provusinc/quoting/commit/57f30ce7ab07f6333daec1836e9e2f62b5b2d9d7))
- **psq-1504:** when to field is left blank default to infinity ([#1189](https://github.com/provusinc/quoting/issues/1189)) ([cf17d3e](https://github.com/provusinc/quoting/commit/cf17d3eb9463c205f271f2fa09342265e0e8f293))
- **psq-4109:** show value replace prior add value ([#1148](https://github.com/provusinc/quoting/issues/1148)) ([9a4ad89](https://github.com/provusinc/quoting/commit/9a4ad89ce607050e3b2326fcd224f285f767cdbc))
- **psq-4115:** calculate and apply headcount volume discounts ([#1201](https://github.com/provusinc/quoting/issues/1201)) ([a1590df](https://github.com/provusinc/quoting/commit/a1590df6aa745bcfa45911c87119f15018594bd0))
- **psq-4160:** Approval Service method to initiate approval with email template ([#1149](https://github.com/provusinc/quoting/issues/1149)) ([132180b](https://github.com/provusinc/quoting/commit/132180ba4f2d020ce9bf68fbf72435721d7365df))
- **psq-4179:** display labor revenue volume discount and format from/to values as currency ([#1184](https://github.com/provusinc/quoting/issues/1184)) ([7ba2249](https://github.com/provusinc/quoting/commit/7ba2249e9ce89cf8e5f9f571a9d2229e83f3157b))
- **psq-4185:** approval apis ([#1182](https://github.com/provusinc/quoting/issues/1182)) ([d7f5a2e](https://github.com/provusinc/quoting/commit/d7f5a2ee66b8cb0021f106000d5c6c14307b329d))
- **psq-4185:** link reject button to reject api ([#1173](https://github.com/provusinc/quoting/issues/1173)) ([e4a4e12](https://github.com/provusinc/quoting/commit/e4a4e12cd57492d24f7365555bf1a00879a4d23e))
- **psq-4185:** update quote status upon rejection ([#1158](https://github.com/provusinc/quoting/issues/1158)) ([144e7d0](https://github.com/provusinc/quoting/commit/144e7d060b4e21305bb1bd50bcc3bda3884734a5))
- **psq-4186:** quote rejection email ([#1160](https://github.com/provusinc/quoting/issues/1160)) ([a6e66f6](https://github.com/provusinc/quoting/commit/a6e66f65d163aeb31a6f93e46dff2e5828678639))
- **psq-4188:** ability to see submitter comments on approval screen ([#1181](https://github.com/provusinc/quoting/issues/1181)) ([ab715e4](https://github.com/provusinc/quoting/commit/ab715e416190be9bec9a8678020bbe1ee1dae6d9))
- **psq-4335:** add labor units picklist ([32f1799](https://github.com/provusinc/quoting/commit/32f179963e5ed63e55b2c3b3f7467fe4cb543a2d))
- **psq-4335:** add labor units picklist ([#1186](https://github.com/provusinc/quoting/issues/1186)) ([adf25ca](https://github.com/provusinc/quoting/commit/adf25ca40bb3bd92fc0740c3611fd61ca99389f1))
- **psq-4387:** ability to enter resource hours instead of headcounts ([#1210](https://github.com/provusinc/quoting/issues/1210)) ([7847f38](https://github.com/provusinc/quoting/commit/7847f3858ab47bfc5f471a5b69afa8e6cf5c2eb1))
- **psq-4390:** set time period to hours if labor unit is hours ([#1219](https://github.com/provusinc/quoting/issues/1219)) ([7bda153](https://github.com/provusinc/quoting/commit/7bda1539ab9204864a408d1f2dbf528145f439b2))
- **psq-4436:** estimate template clone, creates duplicate taskparamvaluetemplate record ([#1215](https://github.com/provusinc/quoting/issues/1215)) ([0e516e0](https://github.com/provusinc/quoting/commit/0e516e0528ec7b17262be0d56dba04b1bbbbb4ec))
- **quote totals:** summarize child named ranges ([805ef90](https://github.com/provusinc/quoting/commit/805ef90fd758d0cbd96173a6ece54002b113e215))
- remove currency iso code from the layouts ([b12eed6](https://github.com/provusinc/quoting/commit/b12eed6ac5c28e2f16d0e380dee20b105eab7084))
- remove phases in estimate template tree ([0f9a9ed](https://github.com/provusinc/quoting/commit/0f9a9ed35f96a9f1d5a27e86f6dc890234b1ef50))
- **scenarios:** Ability to Submit a Quote and Scenarios for Approval ([#1151](https://github.com/provusinc/quoting/issues/1151)) ([cffaad8](https://github.com/provusinc/quoting/commit/cffaad830e6aab7aaccf74d27cd6fb600cd5dbf0))
- **scope parameter id:** rename relationship field step 1 ([74a0a39](https://github.com/provusinc/quoting/commit/74a0a39e58af0aee07d237ee772c577a66016856))
- **scope parameter id:** rename relationship field step 1 ([0cb00dd](https://github.com/provusinc/quoting/commit/0cb00dd2b1be1378bb52e462529fdb7364b41bbe))
- **scope parameter id:** rename relationship field step 1 ([f0e5d12](https://github.com/provusinc/quoting/commit/f0e5d1258fdf92d628b3e30d499a3eea5ff5c01c))
- **scope parameter id:** rename relationship field step 2 ([db1fd0a](https://github.com/provusinc/quoting/commit/db1fd0abae1308c2281dbba9af1c3e1134859c6d))
- **submit for approval:** added ability to submit comments for approval ([#1177](https://github.com/provusinc/quoting/issues/1177)) ([7924380](https://github.com/provusinc/quoting/commit/7924380da0ca527883ba8febaed827913e1cd973))
- **trigger build:** add dev hub user to exception emails ([406845d](https://github.com/provusinc/quoting/commit/406845d657e3661ade905f689c1b68af9796b9dc))
- **trigger build:** approval process cannot be included in a managed package ([263faa0](https://github.com/provusinc/quoting/commit/263faa051eeffa36eb639f2e92ee2787ed0341e3))
- **trigger build:** fix build failure from changing api name ([de951ff](https://github.com/provusinc/quoting/commit/de951ff68d209b71dffc73ca6e91745e8a3a1a20))
- **trigger build:** fix double named ranges ([036726a](https://github.com/provusinc/quoting/commit/036726a1d6ddc6c0a787d8842225c716b1e81b77))

### Bug Fixes

- add psq prefix to rejection reason field ([d746e1b](https://github.com/provusinc/quoting/commit/d746e1b4cf1cdeeb89736e29f5ad9bc4cd958d50))
- add psq prefix to rejection reason field ([0b6351e](https://github.com/provusinc/quoting/commit/0b6351ee585ec3c1828c69f6595076414d469bda))
- add volume discount controller to quote manager permission set ([#1198](https://github.com/provusinc/quoting/issues/1198)) ([734c191](https://github.com/provusinc/quoting/commit/734c191c8a9829f685b3c11db514048244cca688))
- allow fractional numbers in scope discovery ([360ca47](https://github.com/provusinc/quoting/commit/360ca47f6d8cb91a02246b56e8847982e682b0c4))
- apex metadata api should not be included ([eb4b5be](https://github.com/provusinc/quoting/commit/eb4b5bed4b1392cb40c923e8c4eb2f820600237d))
- avoid NaN in quantity calculations ([3e8dbcb](https://github.com/provusinc/quoting/commit/3e8dbcb7c7142ea4dd5c07e02ec6131e26ae7ff5))
- cleanup approval emails ([8db1ff7](https://github.com/provusinc/quoting/commit/8db1ff750c472fe60ef2bd8eef181b733f88e595))
- **cola rates admin:** clear out draft values when we delete rows ([#1192](https://github.com/provusinc/quoting/issues/1192)) ([0cf67a6](https://github.com/provusinc/quoting/commit/0cf67a6034729f1cb81813771e470c23f745f2fe))
- convert stringified quantities to whole numbers ([fe37e77](https://github.com/provusinc/quoting/commit/fe37e77cf30e9b06c53ee686ebdf6bcf09cfd575))
- data model for quote volume discount data ([#1142](https://github.com/provusinc/quoting/issues/1142)) ([22093b8](https://github.com/provusinc/quoting/commit/22093b8ec169f5186de2657a52e26cecb3528baf))
- do not count effective discount for cost adjustments ([6bf27ca](https://github.com/provusinc/quoting/commit/6bf27cafaaf215e0dc7bd8f17d1fd56b531531b5))
- **estimate template:** changed sequencing of selected item to be contextual ([#1159](https://github.com/provusinc/quoting/issues/1159)) ([1c92b37](https://github.com/provusinc/quoting/commit/1c92b37781362f109fe38e863c0a0bc604e5fe25))
- fix the submit for approval email references ([5e0d790](https://github.com/provusinc/quoting/commit/5e0d790bca31fab8a213055d67e11bc7ad2e42d2))
- **permissions:** quote manager permissions ([#1168](https://github.com/provusinc/quoting/issues/1168)) ([20f06bb](https://github.com/provusinc/quoting/commit/20f06bb0e8de22a6d1304e370eef89da4d1b43bd))
- populate the before discount amount ([4fb168d](https://github.com/provusinc/quoting/commit/4fb168dca7c1f68ecd25cdb4eb5b0bc21b532d72))
- **psq-1504:** code should handle picklist value missing ([#1194](https://github.com/provusinc/quoting/issues/1194)) ([7539d6e](https://github.com/provusinc/quoting/commit/7539d6ee1f386bc7cf52ff70a29d3e37b43d60a3))
- **psq-1504:** display input fields evenly in event of required validation error ([#1202](https://github.com/provusinc/quoting/issues/1202)) ([0830a5e](https://github.com/provusinc/quoting/commit/0830a5edeb12fb54b7b12d2b22e6ca5faff8ca43))
- **psq-2814:** changes for clone issue ([#1193](https://github.com/provusinc/quoting/issues/1193)) ([5389c50](https://github.com/provusinc/quoting/commit/5389c501d84c9aff4187b272a1bb282ef63be648))
- **psq-2977:** year over year rate field validation changes ([#1200](https://github.com/provusinc/quoting/issues/1200)) ([a449f3a](https://github.com/provusinc/quoting/commit/a449f3aba4759509a0b9e383ce02a8e7f392ec21))
- **psq-3595:** fix user is not able to make scenario primary ([#1153](https://github.com/provusinc/quoting/issues/1153)) ([d745838](https://github.com/provusinc/quoting/commit/d745838b7729330f223d5389559f80c965fa0595))
- **psq-3595:** fix user is not able to make scenario primary ([#1172](https://github.com/provusinc/quoting/issues/1172)) ([2634fb1](https://github.com/provusinc/quoting/commit/2634fb1b8dfe2a30face2a30d02598753aaf1718))
- **psq-4115:** fixing applied by and recalculate volume discount adjustments on remove ([#1214](https://github.com/provusinc/quoting/issues/1214)) ([6755812](https://github.com/provusinc/quoting/commit/6755812f6cbb40f823741e531a9d1e3f87def533))
- **psq-4179:** add feature flag to control access to labor revenue volume discount ([#1204](https://github.com/provusinc/quoting/issues/1204)) ([194f0ab](https://github.com/provusinc/quoting/commit/194f0ab19045425c67652ae94f75731377da4615))
- **psq-4346:** pasting estimate temp activity results in correct sequence number on target ([#1176](https://github.com/provusinc/quoting/issues/1176)) ([db6b427](https://github.com/provusinc/quoting/commit/db6b427618a6febd9d4fb3a724bfdeaf0026b9e8))
- **psq-4394:** committed collaboration read-only issues ([#1221](https://github.com/provusinc/quoting/issues/1221)) ([eb7bd16](https://github.com/provusinc/quoting/commit/eb7bd16d304be90504da1c4088d9cc6cab526773))
- **psq-4395:** Collaboration quote component is keep on loading and component is not visible to the collaboration user ([#1208](https://github.com/provusinc/quoting/issues/1208)) ([b03ad82](https://github.com/provusinc/quoting/commit/b03ad82a2abd692f3621176f9b5a634e80e5e3de))
- **psq-4432:** unable to clone task ([#1171](https://github.com/provusinc/quoting/issues/1171)) ([102f119](https://github.com/provusinc/quoting/commit/102f1193841cc941a269c2634befc3ab6e602775))
- **psq-4435:** cloning scope parameter associated with estimate template, activity group template and activity template ([#1207](https://github.com/provusinc/quoting/issues/1207)) ([a43ba27](https://github.com/provusinc/quoting/commit/a43ba279d07e9fc0df075543741041f78660e537))
- **psq-4437:** avoid duplicate on scopeparams link ([#1154](https://github.com/provusinc/quoting/issues/1154)) ([2a3a915](https://github.com/provusinc/quoting/commit/2a3a9156081a2eb1ed5abf28f2b365f83ccfd1b3))
- **psq-4439:** fix for scope discovery button invisible for cloned estimate ([#1206](https://github.com/provusinc/quoting/issues/1206)) ([43828d3](https://github.com/provusinc/quoting/commit/43828d394f5732bb3b234e5c181bbd0b8d1acf84))
- **psq-4441:** added logic to clone resource splits ([#1178](https://github.com/provusinc/quoting/issues/1178)) ([1bbe5d2](https://github.com/provusinc/quoting/commit/1bbe5d22d695c2dc44a4b689fa96dc085cf1fe20))
- **psq-4443:** added scroll on edit task dialog to view action button in below ([#1162](https://github.com/provusinc/quoting/issues/1162)) ([cf429cc](https://github.com/provusinc/quoting/commit/cf429ccb80bb12f3def31426f2b6efdf53cdadd7))
- **psq-4497:** copy discount amount from named range onto quote ([#1164](https://github.com/provusinc/quoting/issues/1164)) ([724f078](https://github.com/provusinc/quoting/commit/724f0786123f1464cf121cca34ee8568c5aa1444))
- **psq-4498:** missing percentage decimal point in quote compare view ([#1155](https://github.com/provusinc/quoting/issues/1155)) ([d607db2](https://github.com/provusinc/quoting/commit/d607db23d622e84f890bdd22880ccff46bb89281))
- **psq-4500:** add namespace to email template ([#1170](https://github.com/provusinc/quoting/issues/1170)) ([7e10763](https://github.com/provusinc/quoting/commit/7e107637187db95cd4cede833c47b4ffca7a806a))
- **psq-4500:** adjust quote approver email link to approver view ([#1169](https://github.com/provusinc/quoting/issues/1169)) ([75bee34](https://github.com/provusinc/quoting/commit/75bee340f22d847e96da1063f4b400e3c128e905))
- **psq-4502:** disable scenario create button after click ([#1185](https://github.com/provusinc/quoting/issues/1185)) ([9917497](https://github.com/provusinc/quoting/commit/9917497a6118ee592b89a99eae60ee88be35def8))
- **psq-4503:** fix for opportunity not linked when maiking quote primary ([#1195](https://github.com/provusinc/quoting/issues/1195)) ([aa3bd90](https://github.com/provusinc/quoting/commit/aa3bd90a4c99588ec476e1b477cdfbe764658831))
- **psq-4536:** weekly naming three letter months ([#1167](https://github.com/provusinc/quoting/issues/1167)) ([fd5fec3](https://github.com/provusinc/quoting/commit/fd5fec37837bcc572aee446e996decfaebb21c5f))
- **psq-4642:** do not close discount dialog when there is an error ([cca8889](https://github.com/provusinc/quoting/commit/cca888920c1214d4a8f938ee6d374be90af9b3b8))
- **psq-4658:** converted stringified numbers to number ([#1209](https://github.com/provusinc/quoting/issues/1209)) ([9ca25d0](https://github.com/provusinc/quoting/commit/9ca25d0b7ee205b88e11855985260417a7646c14))
- **psq-4661:** update cola rate review button intent ([#1222](https://github.com/provusinc/quoting/issues/1222)) ([13e22a1](https://github.com/provusinc/quoting/commit/13e22a13746209a25a160fd547eee31bb6f58c8e))
- **psq-4664:** removing pass through rates issue ([#1223](https://github.com/provusinc/quoting/issues/1223)) ([76649f4](https://github.com/provusinc/quoting/commit/76649f4c12ab9df537609a2321e3ad2d96246fa3))
- **psq-4670:** post install script to include labor revenue picklist value ([#1218](https://github.com/provusinc/quoting/issues/1218)) ([9825cf6](https://github.com/provusinc/quoting/commit/9825cf618d5ae49d793f46d88a49c9eee64c1670))
- **psq-4673:** validate index before removing all unrelated volume discount adjustments ([#1220](https://github.com/provusinc/quoting/issues/1220)) ([44fbba1](https://github.com/provusinc/quoting/commit/44fbba16ecd634eb233feb217f13892030f04e55))
- **psq-4746:** incorrect year over year validation for non-global rate ([#1224](https://github.com/provusinc/quoting/issues/1224)) ([c200bc3](https://github.com/provusinc/quoting/commit/c200bc3f55a5e499c0ac5a4e0bac916800324d95))
- quote ancillaries update issues ([bc35c7f](https://github.com/provusinc/quoting/commit/bc35c7f58eb23b51a26e0fb90ce1090426a9bf9b))
- **quote compare:** disable reject button when text is blank ([#1196](https://github.com/provusinc/quoting/issues/1196)) ([f78c63b](https://github.com/provusinc/quoting/commit/f78c63b2bb8b4b5cbf8806c2f29689335194cb95))
- run metadata api code in future method ([7a9f62e](https://github.com/provusinc/quoting/commit/7a9f62ecdfcc01d4b55c8ef01617b485f017d2c0))
- run metadata api code in future method ([b94ef7e](https://github.com/provusinc/quoting/commit/b94ef7e89ea36e22c6c13ce31db1fe6a34084904))
- run metadata api code in future method ([9e27ae5](https://github.com/provusinc/quoting/commit/9e27ae5d6f49b36a1f86a9fcf667b01523acd5da))
- save new quote period groups in quote totals ([07a2e25](https://github.com/provusinc/quoting/commit/07a2e25d6ec9bcfd638dd03fe6a307f7a47aa786))
- set the approval rejection reason before rejecting ([9367206](https://github.com/provusinc/quoting/commit/9367206fbe51a57de35ce7688454c0c303f34984))
- set the approved quotes type to quote ([#1188](https://github.com/provusinc/quoting/issues/1188)) ([a902092](https://github.com/provusinc/quoting/commit/a902092a9f7821cfb3d13c2fafde1186f761bffb))
- show the path bar for inactive scenarios ([b4fd2e6](https://github.com/provusinc/quoting/commit/b4fd2e6a10d94ba674f7cf99095c46f3bea573ee))
- **submit approval:** submit approval bug ([#1187](https://github.com/provusinc/quoting/issues/1187)) ([79763d8](https://github.com/provusinc/quoting/commit/79763d827ce3b57499c2c2327cae6a3ba8e0c692))
- update the recipient line of the rejection approval email ([c6f1d5f](https://github.com/provusinc/quoting/commit/c6f1d5fd5483c90fd769bbe3e0ce8a42b989be99))
- upgrade async from 3.2.3 to 3.2.4 ([#1150](https://github.com/provusinc/quoting/issues/1150)) ([0599f54](https://github.com/provusinc/quoting/commit/0599f54e24c672b908198aaf2bb7dfdb039d81f9))
- **volume discounting:** fix some issues with volume discount application ([4096a0c](https://github.com/provusinc/quoting/commit/4096a0c5dde36d404f4f01e698f82e2a0d25fbd9))
- **volume discounts:** remove adjustments when swapping volume discount category ([#1205](https://github.com/provusinc/quoting/issues/1205)) ([d370cfe](https://github.com/provusinc/quoting/commit/d370cfe245fabf8600e5fd5943b000adcc184c20))

### Reverts

- Revert "fix(psq-3595): fix user is not able to make scenario primary (#1153)" (#1157) ([e150467](https://github.com/provusinc/quoting/commit/e150467269308f0f88c08a7b9517e8d0d9618346)), closes [#1153](https://github.com/provusinc/quoting/issues/1153) [#1157](https://github.com/provusinc/quoting/issues/1157)

## [2.33.0-next.29](https://github.com/provusinc/quoting/compare/v2.33.0-next.28...v2.33.0-next.29) (2022-07-13)

### Features

- **adjustment method picklist:** remove restricted picklist ([000dadf](https://github.com/provusinc/quoting/commit/000dadfa05d4553497022222027679a174725967))

### Bug Fixes

- **psq-4435:** cloning scope parameter associated with estimate template, activity group template and activity template ([#1207](https://github.com/provusinc/quoting/issues/1207)) ([a43ba27](https://github.com/provusinc/quoting/commit/a43ba279d07e9fc0df075543741041f78660e537))
- **psq-4439:** fix for scope discovery button invisible for cloned estimate ([#1206](https://github.com/provusinc/quoting/issues/1206)) ([43828d3](https://github.com/provusinc/quoting/commit/43828d394f5732bb3b234e5c181bbd0b8d1acf84))

## [2.33.0-next.28](https://github.com/provusinc/quoting/compare/v2.33.0-next.27...v2.33.0-next.28) (2022-07-13)

### Features

- **psq-4436:** estimate template clone, creates duplicate taskparamvaluetemplate record ([#1215](https://github.com/provusinc/quoting/issues/1215)) ([0e516e0](https://github.com/provusinc/quoting/commit/0e516e0528ec7b17262be0d56dba04b1bbbbb4ec))

### Bug Fixes

- run metadata api code in future method ([7a9f62e](https://github.com/provusinc/quoting/commit/7a9f62ecdfcc01d4b55c8ef01617b485f017d2c0))
- run metadata api code in future method ([b94ef7e](https://github.com/provusinc/quoting/commit/b94ef7e89ea36e22c6c13ce31db1fe6a34084904))
- run metadata api code in future method ([9e27ae5](https://github.com/provusinc/quoting/commit/9e27ae5d6f49b36a1f86a9fcf667b01523acd5da))

## [2.33.0-next.27](https://github.com/provusinc/quoting/compare/v2.33.0-next.26...v2.33.0-next.27) (2022-07-13)

### Features

- **metadata api:** breakup the metadata api into individual classes ([a2bea4c](https://github.com/provusinc/quoting/commit/a2bea4c6af58577c0eb904f23c4cd8cfa373e855))
- **psq-4390:** set time period to hours if labor unit is hours ([#1219](https://github.com/provusinc/quoting/issues/1219)) ([7bda153](https://github.com/provusinc/quoting/commit/7bda1539ab9204864a408d1f2dbf528145f439b2))

### Bug Fixes

- **psq-4394:** committed collaboration read-only issues ([#1221](https://github.com/provusinc/quoting/issues/1221)) ([eb7bd16](https://github.com/provusinc/quoting/commit/eb7bd16d304be90504da1c4088d9cc6cab526773))
- **psq-4661:** update cola rate review button intent ([#1222](https://github.com/provusinc/quoting/issues/1222)) ([13e22a1](https://github.com/provusinc/quoting/commit/13e22a13746209a25a160fd547eee31bb6f58c8e))
- **psq-4670:** post install script to include labor revenue picklist value ([#1218](https://github.com/provusinc/quoting/issues/1218)) ([9825cf6](https://github.com/provusinc/quoting/commit/9825cf618d5ae49d793f46d88a49c9eee64c1670))
- **psq-4673:** validate index before removing all unrelated volume discount adjustments ([#1220](https://github.com/provusinc/quoting/issues/1220)) ([44fbba1](https://github.com/provusinc/quoting/commit/44fbba16ecd634eb233feb217f13892030f04e55))
- update the recipient line of the rejection approval email ([c6f1d5f](https://github.com/provusinc/quoting/commit/c6f1d5fd5483c90fd769bbe3e0ce8a42b989be99))

## [2.33.0-next.26](https://github.com/provusinc/quoting/compare/v2.33.0-next.25...v2.33.0-next.26) (2022-07-12)

### Features

- **psq-4387:** ability to enter resource hours instead of headcounts ([#1210](https://github.com/provusinc/quoting/issues/1210)) ([7847f38](https://github.com/provusinc/quoting/commit/7847f3858ab47bfc5f471a5b69afa8e6cf5c2eb1))
- remove phases in estimate template tree ([0f9a9ed](https://github.com/provusinc/quoting/commit/0f9a9ed35f96a9f1d5a27e86f6dc890234b1ef50))
- **trigger build:** add dev hub user to exception emails ([406845d](https://github.com/provusinc/quoting/commit/406845d657e3661ade905f689c1b68af9796b9dc))

### Bug Fixes

- **psq-4115:** fixing applied by and recalculate volume discount adjustments on remove ([#1214](https://github.com/provusinc/quoting/issues/1214)) ([6755812](https://github.com/provusinc/quoting/commit/6755812f6cbb40f823741e531a9d1e3f87def533))

## [2.33.0-next.25](https://github.com/provusinc/quoting/compare/v2.33.0-next.24...v2.33.0-next.25) (2022-07-12)

### Features

- **collab:** show link to collab quote in section header ([#1211](https://github.com/provusinc/quoting/issues/1211)) ([d5edb67](https://github.com/provusinc/quoting/commit/d5edb67ae847a9509916b54243b27f6556a63e3c))
- post install script to add missing picklist values ([#1212](https://github.com/provusinc/quoting/issues/1212)) ([0450c8c](https://github.com/provusinc/quoting/commit/0450c8cde4139d5914b32a766ffb325af361d9c7))

### Bug Fixes

- **volume discounts:** remove adjustments when swapping volume discount category ([#1205](https://github.com/provusinc/quoting/issues/1205)) ([d370cfe](https://github.com/provusinc/quoting/commit/d370cfe245fabf8600e5fd5943b000adcc184c20))

## [2.33.0-next.24](https://github.com/provusinc/quoting/compare/v2.33.0-next.23...v2.33.0-next.24) (2022-07-11)

### Bug Fixes

- **psq-4658:** converted stringified numbers to number ([#1209](https://github.com/provusinc/quoting/issues/1209)) ([9ca25d0](https://github.com/provusinc/quoting/commit/9ca25d0b7ee205b88e11855985260417a7646c14))

## [2.33.0-next.23](https://github.com/provusinc/quoting/compare/v2.33.0-next.22...v2.33.0-next.23) (2022-07-11)

### Bug Fixes

- **psq-4395:** Collaboration quote component is keep on loading and component is not visible to the collaboration user ([#1208](https://github.com/provusinc/quoting/issues/1208)) ([b03ad82](https://github.com/provusinc/quoting/commit/b03ad82a2abd692f3621176f9b5a634e80e5e3de))

## [2.33.0-next.22](https://github.com/provusinc/quoting/compare/v2.33.0-next.21...v2.33.0-next.22) (2022-07-11)

### Bug Fixes

- save new quote period groups in quote totals ([07a2e25](https://github.com/provusinc/quoting/commit/07a2e25d6ec9bcfd638dd03fe6a307f7a47aa786))

## [2.33.0-next.21](https://github.com/provusinc/quoting/compare/v2.33.0-next.20...v2.33.0-next.21) (2022-07-11)

### Features

- **trigger build:** fix double named ranges ([036726a](https://github.com/provusinc/quoting/commit/036726a1d6ddc6c0a787d8842225c716b1e81b77))

### Bug Fixes

- **psq-4179:** add feature flag to control access to labor revenue volume discount ([#1204](https://github.com/provusinc/quoting/issues/1204)) ([194f0ab](https://github.com/provusinc/quoting/commit/194f0ab19045425c67652ae94f75731377da4615))

## [2.33.0-next.20](https://github.com/provusinc/quoting/compare/v2.33.0-next.19...v2.33.0-next.20) (2022-07-09)

### Bug Fixes

- **volume discounting:** fix some issues with volume discount application ([4096a0c](https://github.com/provusinc/quoting/commit/4096a0c5dde36d404f4f01e698f82e2a0d25fbd9))

## [2.33.0-next.19](https://github.com/provusinc/quoting/compare/v2.33.0-next.18...v2.33.0-next.19) (2022-07-09)

### Features

- **psq-4115:** calculate and apply headcount volume discounts ([#1201](https://github.com/provusinc/quoting/issues/1201)) ([a1590df](https://github.com/provusinc/quoting/commit/a1590df6aa745bcfa45911c87119f15018594bd0))

### Bug Fixes

- **psq-1504:** display input fields evenly in event of required validation error ([#1202](https://github.com/provusinc/quoting/issues/1202)) ([0830a5e](https://github.com/provusinc/quoting/commit/0830a5edeb12fb54b7b12d2b22e6ca5faff8ca43))

## [2.33.0-next.18](https://github.com/provusinc/quoting/compare/v2.33.0-next.17...v2.33.0-next.18) (2022-07-08)

### Features

- **quote totals:** summarize child named ranges ([805ef90](https://github.com/provusinc/quoting/commit/805ef90fd758d0cbd96173a6ece54002b113e215))

## [2.33.0-next.17](https://github.com/provusinc/quoting/compare/v2.33.0-next.16...v2.33.0-next.17) (2022-07-08)

### Bug Fixes

- add psq prefix to rejection reason field ([d746e1b](https://github.com/provusinc/quoting/commit/d746e1b4cf1cdeeb89736e29f5ad9bc4cd958d50))
- add psq prefix to rejection reason field ([0b6351e](https://github.com/provusinc/quoting/commit/0b6351ee585ec3c1828c69f6595076414d469bda))
- **psq-2977:** year over year rate field validation changes ([#1200](https://github.com/provusinc/quoting/issues/1200)) ([a449f3a](https://github.com/provusinc/quoting/commit/a449f3aba4759509a0b9e383ce02a8e7f392ec21))
- set the approval rejection reason before rejecting ([9367206](https://github.com/provusinc/quoting/commit/9367206fbe51a57de35ce7688454c0c303f34984))

## [2.33.0-next.16](https://github.com/provusinc/quoting/compare/v2.33.0-next.15...v2.33.0-next.16) (2022-07-08)

### Bug Fixes

- add volume discount controller to quote manager permission set ([#1198](https://github.com/provusinc/quoting/issues/1198)) ([734c191](https://github.com/provusinc/quoting/commit/734c191c8a9829f685b3c11db514048244cca688))
- apex metadata api should not be included ([eb4b5be](https://github.com/provusinc/quoting/commit/eb4b5bed4b1392cb40c923e8c4eb2f820600237d))
- do not count effective discount for cost adjustments ([6bf27ca](https://github.com/provusinc/quoting/commit/6bf27cafaaf215e0dc7bd8f17d1fd56b531531b5))
- **psq-4642:** do not close discount dialog when there is an error ([cca8889](https://github.com/provusinc/quoting/commit/cca888920c1214d4a8f938ee6d374be90af9b3b8))
- **quote compare:** disable reject button when text is blank ([#1196](https://github.com/provusinc/quoting/issues/1196)) ([f78c63b](https://github.com/provusinc/quoting/commit/f78c63b2bb8b4b5cbf8806c2f29689335194cb95))

## [2.33.0-next.15](https://github.com/provusinc/quoting/compare/v2.33.0-next.14...v2.33.0-next.15) (2022-07-08)

### Bug Fixes

- show the path bar for inactive scenarios ([b4fd2e6](https://github.com/provusinc/quoting/commit/b4fd2e6a10d94ba674f7cf99095c46f3bea573ee))

## [2.33.0-next.14](https://github.com/provusinc/quoting/compare/v2.33.0-next.13...v2.33.0-next.14) (2022-07-08)

### Features

- **approval email:** add formulae for account and quote name lookups ([d1af285](https://github.com/provusinc/quoting/commit/d1af285087e522828e0a3a63728d3ee46397dc81))

### Bug Fixes

- **psq-1504:** code should handle picklist value missing ([#1194](https://github.com/provusinc/quoting/issues/1194)) ([7539d6e](https://github.com/provusinc/quoting/commit/7539d6ee1f386bc7cf52ff70a29d3e37b43d60a3))
- **psq-4503:** fix for opportunity not linked when maiking quote primary ([#1195](https://github.com/provusinc/quoting/issues/1195)) ([aa3bd90](https://github.com/provusinc/quoting/commit/aa3bd90a4c99588ec476e1b477cdfbe764658831))

## [2.33.0-next.13](https://github.com/provusinc/quoting/compare/v2.33.0-next.12...v2.33.0-next.13) (2022-07-08)

### Bug Fixes

- **cola rates admin:** clear out draft values when we delete rows ([#1192](https://github.com/provusinc/quoting/issues/1192)) ([0cf67a6](https://github.com/provusinc/quoting/commit/0cf67a6034729f1cb81813771e470c23f745f2fe))
- **psq-2814:** changes for clone issue ([#1193](https://github.com/provusinc/quoting/issues/1193)) ([5389c50](https://github.com/provusinc/quoting/commit/5389c501d84c9aff4187b272a1bb282ef63be648))

## [2.33.0-next.12](https://github.com/provusinc/quoting/compare/v2.33.0-next.11...v2.33.0-next.12) (2022-07-08)

### Features

- **psq-1504:** code defect when opening volume discount dialog for first time on quote ([#1190](https://github.com/provusinc/quoting/issues/1190)) ([6d50016](https://github.com/provusinc/quoting/commit/6d5001623b93525855a04932a4f7d280b83a0caf))

### Bug Fixes

- set the approved quotes type to quote ([#1188](https://github.com/provusinc/quoting/issues/1188)) ([a902092](https://github.com/provusinc/quoting/commit/a902092a9f7821cfb3d13c2fafde1186f761bffb))

## [2.33.0-next.11](https://github.com/provusinc/quoting/compare/v2.33.0-next.10...v2.33.0-next.11) (2022-07-08)

### Features

- **psq-1504:** when to field is left blank default to infinity ([#1189](https://github.com/provusinc/quoting/issues/1189)) ([cf17d3e](https://github.com/provusinc/quoting/commit/cf17d3eb9463c205f271f2fa09342265e0e8f293))

### Bug Fixes

- cleanup approval emails ([8db1ff7](https://github.com/provusinc/quoting/commit/8db1ff750c472fe60ef2bd8eef181b733f88e595))

## [2.33.0-next.10](https://github.com/provusinc/quoting/compare/v2.33.0-next.9...v2.33.0-next.10) (2022-07-08)

### Features

- **psq-4335:** add labor units picklist ([32f1799](https://github.com/provusinc/quoting/commit/32f179963e5ed63e55b2c3b3f7467fe4cb543a2d))
- **psq-4335:** add labor units picklist ([#1186](https://github.com/provusinc/quoting/issues/1186)) ([adf25ca](https://github.com/provusinc/quoting/commit/adf25ca40bb3bd92fc0740c3611fd61ca99389f1))

### Bug Fixes

- fix the submit for approval email references ([5e0d790](https://github.com/provusinc/quoting/commit/5e0d790bca31fab8a213055d67e11bc7ad2e42d2))
- **psq-4441:** added logic to clone resource splits ([#1178](https://github.com/provusinc/quoting/issues/1178)) ([1bbe5d2](https://github.com/provusinc/quoting/commit/1bbe5d22d695c2dc44a4b689fa96dc085cf1fe20))

## [2.33.0-next.9](https://github.com/provusinc/quoting/compare/v2.33.0-next.8...v2.33.0-next.9) (2022-07-07)

### Bug Fixes

- **submit approval:** submit approval bug ([#1187](https://github.com/provusinc/quoting/issues/1187)) ([79763d8](https://github.com/provusinc/quoting/commit/79763d827ce3b57499c2c2327cae6a3ba8e0c692))

## [2.33.0-next.8](https://github.com/provusinc/quoting/compare/v2.33.0-next.7...v2.33.0-next.8) (2022-07-07)

### Features

- **psq-4179:** display labor revenue volume discount and format from/to values as currency ([#1184](https://github.com/provusinc/quoting/issues/1184)) ([7ba2249](https://github.com/provusinc/quoting/commit/7ba2249e9ce89cf8e5f9f571a9d2229e83f3157b))
- **psq-4185:** approval apis ([#1182](https://github.com/provusinc/quoting/issues/1182)) ([d7f5a2e](https://github.com/provusinc/quoting/commit/d7f5a2ee66b8cb0021f106000d5c6c14307b329d))

### Bug Fixes

- **psq-4502:** disable scenario create button after click ([#1185](https://github.com/provusinc/quoting/issues/1185)) ([9917497](https://github.com/provusinc/quoting/commit/9917497a6118ee592b89a99eae60ee88be35def8))

## [2.33.0-next.7](https://github.com/provusinc/quoting/compare/v2.33.0-next.6...v2.33.0-next.7) (2022-07-07)

### Features

- **psq-4188:** ability to see submitter comments on approval screen ([#1181](https://github.com/provusinc/quoting/issues/1181)) ([ab715e4](https://github.com/provusinc/quoting/commit/ab715e416190be9bec9a8678020bbe1ee1dae6d9))
- **submit for approval:** added ability to submit comments for approval ([#1177](https://github.com/provusinc/quoting/issues/1177)) ([7924380](https://github.com/provusinc/quoting/commit/7924380da0ca527883ba8febaed827913e1cd973))

### Bug Fixes

- **psq-4432:** unable to clone task ([#1171](https://github.com/provusinc/quoting/issues/1171)) ([102f119](https://github.com/provusinc/quoting/commit/102f1193841cc941a269c2634befc3ab6e602775))

## [2.33.0-next.6](https://github.com/provusinc/quoting/compare/v2.33.0-next.5...v2.33.0-next.6) (2022-07-07)

### Features

- **psq-1504:** make volume discount dtos param named in ui code ([#1180](https://github.com/provusinc/quoting/issues/1180)) ([7839dce](https://github.com/provusinc/quoting/commit/7839dce478dd07c5eba3febf149f62a8918301b8))

## [2.33.0-next.5](https://github.com/provusinc/quoting/compare/v2.33.0-next.4...v2.33.0-next.5) (2022-07-07)

### Bug Fixes

- **psq-3595:** fix user is not able to make scenario primary ([#1172](https://github.com/provusinc/quoting/issues/1172)) ([2634fb1](https://github.com/provusinc/quoting/commit/2634fb1b8dfe2a30face2a30d02598753aaf1718))

## [2.33.0-next.4](https://github.com/provusinc/quoting/compare/v2.33.0-next.3...v2.33.0-next.4) (2022-07-07)

### Features

- **psq-1504:** apex code, apex tests and supporting frontend code for volume discount API ([#1175](https://github.com/provusinc/quoting/issues/1175)) ([7cccf65](https://github.com/provusinc/quoting/commit/7cccf6538cb02c2917605efbe1c8a612791cd63a))

## [2.33.0-next.3](https://github.com/provusinc/quoting/compare/v2.33.0-next.2...v2.33.0-next.3) (2022-07-06)

### Features

- **approval email notification:** add primary quote ([95d464e](https://github.com/provusinc/quoting/commit/95d464ef977d33b74198f47356ad9834c65be9cb))
- **approval email notification:** add primary quote ([#1174](https://github.com/provusinc/quoting/issues/1174)) ([3473b51](https://github.com/provusinc/quoting/commit/3473b51b00bb38f749afbb90e33d3a5be109f934))

### Bug Fixes

- avoid NaN in quantity calculations ([3e8dbcb](https://github.com/provusinc/quoting/commit/3e8dbcb7c7142ea4dd5c07e02ec6131e26ae7ff5))
- **psq-4346:** pasting estimate temp activity results in correct sequence number on target ([#1176](https://github.com/provusinc/quoting/issues/1176)) ([db6b427](https://github.com/provusinc/quoting/commit/db6b427618a6febd9d4fb3a724bfdeaf0026b9e8))

## [2.33.0-next.2](https://github.com/provusinc/quoting/compare/v2.33.0-next.1...v2.33.0-next.2) (2022-07-06)

### Features

- **psq-4185:** link reject button to reject api ([#1173](https://github.com/provusinc/quoting/issues/1173)) ([e4a4e12](https://github.com/provusinc/quoting/commit/e4a4e12cd57492d24f7365555bf1a00879a4d23e))

## [2.33.0-next.1](https://github.com/provusinc/quoting/compare/v2.32.3...v2.33.0-next.1) (2022-07-06)

### Features

- **3171:** ability to approve a quote in the quote compare page ([#1152](https://github.com/provusinc/quoting/issues/1152)) ([11f7590](https://github.com/provusinc/quoting/commit/11f7590e54c2ae87fdfc37ba9dad783b86164f75))
- **psq-1504:** rename quote volume discount object ([#1166](https://github.com/provusinc/quoting/issues/1166)) ([7a2b571](https://github.com/provusinc/quoting/commit/7a2b571e5425b21259fb81146f89f7bc825eee86))
- **psq-1504:** user can edit volume discount fields and receive validation feedback ([#1156](https://github.com/provusinc/quoting/issues/1156)) ([57f30ce](https://github.com/provusinc/quoting/commit/57f30ce7ab07f6333daec1836e9e2f62b5b2d9d7))
- **psq-4109:** show value replace prior add value ([#1148](https://github.com/provusinc/quoting/issues/1148)) ([9a4ad89](https://github.com/provusinc/quoting/commit/9a4ad89ce607050e3b2326fcd224f285f767cdbc))
- **psq-4160:** Approval Service method to initiate approval with email template ([#1149](https://github.com/provusinc/quoting/issues/1149)) ([132180b](https://github.com/provusinc/quoting/commit/132180ba4f2d020ce9bf68fbf72435721d7365df))
- **psq-4185:** update quote status upon rejection ([#1158](https://github.com/provusinc/quoting/issues/1158)) ([144e7d0](https://github.com/provusinc/quoting/commit/144e7d060b4e21305bb1bd50bcc3bda3884734a5))
- **psq-4186:** quote rejection email ([#1160](https://github.com/provusinc/quoting/issues/1160)) ([a6e66f6](https://github.com/provusinc/quoting/commit/a6e66f65d163aeb31a6f93e46dff2e5828678639))
- remove currency iso code from the layouts ([b12eed6](https://github.com/provusinc/quoting/commit/b12eed6ac5c28e2f16d0e380dee20b105eab7084))
- **scenarios:** Ability to Submit a Quote and Scenarios for Approval ([#1151](https://github.com/provusinc/quoting/issues/1151)) ([cffaad8](https://github.com/provusinc/quoting/commit/cffaad830e6aab7aaccf74d27cd6fb600cd5dbf0))
- **scope parameter id:** rename relationship field step 1 ([74a0a39](https://github.com/provusinc/quoting/commit/74a0a39e58af0aee07d237ee772c577a66016856))
- **scope parameter id:** rename relationship field step 1 ([0cb00dd](https://github.com/provusinc/quoting/commit/0cb00dd2b1be1378bb52e462529fdb7364b41bbe))
- **scope parameter id:** rename relationship field step 1 ([f0e5d12](https://github.com/provusinc/quoting/commit/f0e5d1258fdf92d628b3e30d499a3eea5ff5c01c))
- **scope parameter id:** rename relationship field step 2 ([db1fd0a](https://github.com/provusinc/quoting/commit/db1fd0abae1308c2281dbba9af1c3e1134859c6d))
- **trigger build:** approval process cannot be included in a managed package ([263faa0](https://github.com/provusinc/quoting/commit/263faa051eeffa36eb639f2e92ee2787ed0341e3))
- **trigger build:** fix build failure from changing api name ([de951ff](https://github.com/provusinc/quoting/commit/de951ff68d209b71dffc73ca6e91745e8a3a1a20))

### Bug Fixes

- allow fractional numbers in scope discovery ([360ca47](https://github.com/provusinc/quoting/commit/360ca47f6d8cb91a02246b56e8847982e682b0c4))
- convert stringified quantities to whole numbers ([fe37e77](https://github.com/provusinc/quoting/commit/fe37e77cf30e9b06c53ee686ebdf6bcf09cfd575))
- data model for quote volume discount data ([#1142](https://github.com/provusinc/quoting/issues/1142)) ([22093b8](https://github.com/provusinc/quoting/commit/22093b8ec169f5186de2657a52e26cecb3528baf))
- **estimate template:** changed sequencing of selected item to be contextual ([#1159](https://github.com/provusinc/quoting/issues/1159)) ([1c92b37](https://github.com/provusinc/quoting/commit/1c92b37781362f109fe38e863c0a0bc604e5fe25))
- **permissions:** quote manager permissions ([#1168](https://github.com/provusinc/quoting/issues/1168)) ([20f06bb](https://github.com/provusinc/quoting/commit/20f06bb0e8de22a6d1304e370eef89da4d1b43bd))
- populate the before discount amount ([4fb168d](https://github.com/provusinc/quoting/commit/4fb168dca7c1f68ecd25cdb4eb5b0bc21b532d72))
- **psq-3595:** fix user is not able to make scenario primary ([#1153](https://github.com/provusinc/quoting/issues/1153)) ([d745838](https://github.com/provusinc/quoting/commit/d745838b7729330f223d5389559f80c965fa0595))
- **psq-4437:** avoid duplicate on scopeparams link ([#1154](https://github.com/provusinc/quoting/issues/1154)) ([2a3a915](https://github.com/provusinc/quoting/commit/2a3a9156081a2eb1ed5abf28f2b365f83ccfd1b3))
- **psq-4443:** added scroll on edit task dialog to view action button in below ([#1162](https://github.com/provusinc/quoting/issues/1162)) ([cf429cc](https://github.com/provusinc/quoting/commit/cf429ccb80bb12f3def31426f2b6efdf53cdadd7))
- **psq-4497:** copy discount amount from named range onto quote ([#1164](https://github.com/provusinc/quoting/issues/1164)) ([724f078](https://github.com/provusinc/quoting/commit/724f0786123f1464cf121cca34ee8568c5aa1444))
- **psq-4498:** missing percentage decimal point in quote compare view ([#1155](https://github.com/provusinc/quoting/issues/1155)) ([d607db2](https://github.com/provusinc/quoting/commit/d607db23d622e84f890bdd22880ccff46bb89281))
- **psq-4500:** add namespace to email template ([#1170](https://github.com/provusinc/quoting/issues/1170)) ([7e10763](https://github.com/provusinc/quoting/commit/7e107637187db95cd4cede833c47b4ffca7a806a))
- **psq-4500:** adjust quote approver email link to approver view ([#1169](https://github.com/provusinc/quoting/issues/1169)) ([75bee34](https://github.com/provusinc/quoting/commit/75bee340f22d847e96da1063f4b400e3c128e905))
- **psq-4536:** weekly naming three letter months ([#1167](https://github.com/provusinc/quoting/issues/1167)) ([fd5fec3](https://github.com/provusinc/quoting/commit/fd5fec37837bcc572aee446e996decfaebb21c5f))
- quote ancillaries update issues ([bc35c7f](https://github.com/provusinc/quoting/commit/bc35c7f58eb23b51a26e0fb90ce1090426a9bf9b))
- upgrade async from 3.2.3 to 3.2.4 ([#1150](https://github.com/provusinc/quoting/issues/1150)) ([0599f54](https://github.com/provusinc/quoting/commit/0599f54e24c672b908198aaf2bb7dfdb039d81f9))

### Reverts

- Revert "fix(psq-3595): fix user is not able to make scenario primary (#1153)" (#1157) ([e150467](https://github.com/provusinc/quoting/commit/e150467269308f0f88c08a7b9517e8d0d9618346)), closes [#1153](https://github.com/provusinc/quoting/issues/1153) [#1157](https://github.com/provusinc/quoting/issues/1157)

### [2.32.3](https://github.com/provusinc/quoting/compare/v2.32.2...v2.32.3) (2022-07-06)

### Bug Fixes

- quote ancillaries update issues ([c918e83](https://github.com/provusinc/quoting/commit/c918e832fddbcc7e0665d29fd28ac295423344e3))

### [2.32.2](https://github.com/provusinc/quoting/compare/v2.32.1...v2.32.2) (2022-06-29)

### Bug Fixes

- convert stringified quantities to whole numbers ([8df9633](https://github.com/provusinc/quoting/commit/8df9633a3ee4bfb9d0c05500cc20e9fa33e5d7fc))

### [2.32.1](https://github.com/provusinc/quoting/compare/v2.32.0...v2.32.1) (2022-06-28)

### Bug Fixes

- allow fractional numbers in scope discovery ([9122dbb](https://github.com/provusinc/quoting/commit/9122dbb28cfc6890c40d76da432cf49414c58465))

## [2.32.0](https://github.com/provusinc/quoting/compare/v2.31.2...v2.32.0) (2022-06-28)

### Features

- add support for period named ranges ([7a56ce3](https://github.com/provusinc/quoting/commit/7a56ce394c3d4eb8f4c465a380c52111b9009eeb))
- **approval process:** introduce approval process data model ([#1146](https://github.com/provusinc/quoting/issues/1146)) ([f19ab05](https://github.com/provusinc/quoting/commit/f19ab05e1cc6aed42d7316634bded57c4f308096))
- **approvals:** added new submit for approval dialog ([#1134](https://github.com/provusinc/quoting/issues/1134)) ([ed83550](https://github.com/provusinc/quoting/commit/ed835505eb8195f5bd1ef31d7404798b6781fea4))
- **cola:** auto apply cola rates to the quote on add/remove ([8191b2f](https://github.com/provusinc/quoting/commit/8191b2f694ec48208a64298e39fa0483ad49ac0a))
- **cola:** auto apply cola rates to the quote on add/remove ([b49d399](https://github.com/provusinc/quoting/commit/b49d39948e8dad147536f067307b34d7600e8eb3))
- **cola:** auto apply cola rates to the quote on add/remove ([c4fd843](https://github.com/provusinc/quoting/commit/c4fd8436ea66c98a8547103580c81c20e76490aa))
- **cola:** auto apply cola rates to the quote on add/remove ([c8311d6](https://github.com/provusinc/quoting/commit/c8311d6b5f5cc4216b69b9e3ef947291cd49213b))
- **cola:** auto apply cola rates to the quote on add/remove ([e153220](https://github.com/provusinc/quoting/commit/e1532206534c485f6b237cda29e386ed5f6c0177))
- enhance the cola worksheet display for pass-through ([4b9ec64](https://github.com/provusinc/quoting/commit/4b9ec64aa117d4f6b36c3cbe9564126534eb0552))
- **estimate template:** api for copying and resequencing tasks, activities, activity groups ([#1067](https://github.com/provusinc/quoting/issues/1067)) ([36fe71b](https://github.com/provusinc/quoting/commit/36fe71bd78d2a360699815f9c3111237b246ee44))
- **pass-through:** pass-through override on location level ([7ad05c4](https://github.com/provusinc/quoting/commit/7ad05c4060b27e18e1433f24dbfbed2f38e3397f))
- **psq-2915:** weekday calendar alignment ([#1072](https://github.com/provusinc/quoting/issues/1072)) ([d21e55f](https://github.com/provusinc/quoting/commit/d21e55ffec0a5fdc3154db6c239f3739b192c43a))
- **psq-3358:** apply pass through to a quote ([#1129](https://github.com/provusinc/quoting/issues/1129)) ([0a6cca4](https://github.com/provusinc/quoting/commit/0a6cca4a69e34826d3b7760c846acefcf0cc6979))
- **psq-3398:** ability to copy/paste activity groups, activities and tasks of estimate template ([#1120](https://github.com/provusinc/quoting/issues/1120)) ([c1f62d8](https://github.com/provusinc/quoting/commit/c1f62d8729fcb4226392567c36fb6d4e8b42773d))
- **psq-3499:** quote comparison approver view ([#1140](https://github.com/provusinc/quoting/issues/1140)) ([172ac4d](https://github.com/provusinc/quoting/commit/172ac4d2dd12ab26f83ae0c3822c48a0e2284b2e))
- **psq-3562:** added sync to quote button on estimate tab ([#1098](https://github.com/provusinc/quoting/issues/1098)) ([0fe2497](https://github.com/provusinc/quoting/commit/0fe24973b567228251681acece57c5c78d25cb64))
- **psq-3910:** global rate must exist at the quote level ([#1081](https://github.com/provusinc/quoting/issues/1081)) ([d6f0a1e](https://github.com/provusinc/quoting/commit/d6f0a1e2c3f666d7cbdf42a0a2f3633b9c651958))
- **psq-4055:** user is not able to see Success message after save ([13f1c50](https://github.com/provusinc/quoting/commit/13f1c506ed68db58a50b9c2b88660435d8c36ec4))
- **psq-4070:** disallow add period functionality when Quote is Linked to an Estimate ([#1139](https://github.com/provusinc/quoting/issues/1139)) ([98cdefb](https://github.com/provusinc/quoting/commit/98cdefbc770ee4fc767f803556db25debaa5aa40))
- **psq-4184:** cola adjustment worksheet grand total ([#1119](https://github.com/provusinc/quoting/issues/1119)) ([e7b23c8](https://github.com/provusinc/quoting/commit/e7b23c8884b0ac57970af24ce3fce37c93c66431))
- remove erroneous custom label ([35d1876](https://github.com/provusinc/quoting/commit/35d1876564b30f12d365a32e25719c015ad0c23f))
- **trigger build:** cleanup time periods alignment references ([c20e1b5](https://github.com/provusinc/quoting/commit/c20e1b5bea7949599e8e7e5c644e914bc356efed))
- **trigger build:** fix build failure from changing api name ([0e7f5f7](https://github.com/provusinc/quoting/commit/0e7f5f7f73073924e627458399d2c2bd89d395b8))
- **trigger build:** release the split resource feature permanently ([768c1ac](https://github.com/provusinc/quoting/commit/768c1ac486f35296d790236090c0f3b46c881d5a))
- **trigger build:** revert field change ([5a4f3ee](https://github.com/provusinc/quoting/commit/5a4f3ee0a31a0f85de4bd9a05498502d10bcf6bf))

### Bug Fixes

- add permission for is transient flag ([58e8a30](https://github.com/provusinc/quoting/commit/58e8a305fc086b5d1eb800ffd8b4077b10fbf398))
- calculate effective discount for markup amount type ([#1110](https://github.com/provusinc/quoting/issues/1110)) ([6b3cecc](https://github.com/provusinc/quoting/commit/6b3ceccd3f2402733cdfea4340d311e6ec9a5ec8))
- change experimental features language to beta features ([904a321](https://github.com/provusinc/quoting/commit/904a3216a3ea177a5afa93037dfa202f94f1823a))
- **cola adjustment:** show error message after data loads ([#1082](https://github.com/provusinc/quoting/issues/1082)) ([5208fa7](https://github.com/provusinc/quoting/commit/5208fa7ea55eff026a0fb81bc779e96e2ea9b247))
- cola pass through should be calculated as a percentage of revenue ([7ee50c9](https://github.com/provusinc/quoting/commit/7ee50c98721f1efb5f20fd50dc23de6619f4e62e))
- **cola rates:** conditionally disable cola rate actions ([#1097](https://github.com/provusinc/quoting/issues/1097)) ([b0098a5](https://github.com/provusinc/quoting/commit/b0098a5f37c86f7ac3cfec547ed89766a3ffa376))
- **contingencie:** multiple add-on bugs related to baseExtendedAmount field ([#1092](https://github.com/provusinc/quoting/issues/1092)) ([b84a7bb](https://github.com/provusinc/quoting/commit/b84a7bbdd0f1ad1c92501df7526aab71c3e37d3d))
- **custom labels:** ignore node modules to properly retrieve labels from org ([#1133](https://github.com/provusinc/quoting/issues/1133)) ([900c8a9](https://github.com/provusinc/quoting/commit/900c8a9c894dd459edd99791bf7c4300d8cb91be))
- increase revenue as an offset to cost ([f92e9a5](https://github.com/provusinc/quoting/commit/f92e9a5d67465515bbd3161c110c492a715face5))
- **psq-1654:** sorted summary tab resource role ([#1078](https://github.com/provusinc/quoting/issues/1078)) ([1550ba6](https://github.com/provusinc/quoting/commit/1550ba6625c6336cee0aa6bce2cd5844b62cc655))
- **psq-3455:** scope param duplication ([#1102](https://github.com/provusinc/quoting/issues/1102)) ([481ebf1](https://github.com/provusinc/quoting/commit/481ebf196fe75ad1fb719d318a9b970d0344eb13))
- **psq-3611:** fix for task parameter not getting cloned when task is… ([#1077](https://github.com/provusinc/quoting/issues/1077)) ([b5a656d](https://github.com/provusinc/quoting/commit/b5a656d552c69aa8d7b29bbd0112c86eecead07b))
- **psq-3611:** fixing smoke test issues ([#1114](https://github.com/provusinc/quoting/issues/1114)) ([e3e84fc](https://github.com/provusinc/quoting/commit/e3e84fc18eb48089a2389f7d372c7adaa0d803fd))
- **psq-3808:** incorrect cola cost calculation ([#1084](https://github.com/provusinc/quoting/issues/1084)) ([cdef593](https://github.com/provusinc/quoting/commit/cdef593db03050a645241c943e84c16166d99ff7))
- **psq-3840:** remove dropdown strictness ([#1123](https://github.com/provusinc/quoting/issues/1123)) ([379784c](https://github.com/provusinc/quoting/commit/379784cb5779b04194dced1c11db7bd7142a702e))
- **psq-3852:** cola adjustments not calculated for country/state/city ([#1083](https://github.com/provusinc/quoting/issues/1083)) ([f13db71](https://github.com/provusinc/quoting/commit/f13db7133d62cf776551e07869660fc29b927743))
- **psq-3904:** hide activities menu when no estimate linked ([#1075](https://github.com/provusinc/quoting/issues/1075)) ([f43fef4](https://github.com/provusinc/quoting/commit/f43fef4a5276305cffd2d73640afedb5c8604917))
- **psq-3905:** changes for activity and tasks when split resource roles defined ([#1089](https://github.com/provusinc/quoting/issues/1089)) ([648fe84](https://github.com/provusinc/quoting/commit/648fe844449b9edf0065c1650fbe692f5c4b377b)), closes [#1081](https://github.com/provusinc/quoting/issues/1081)
- **psq-3907:** use css style hack to show overflow ([#1093](https://github.com/provusinc/quoting/issues/1093)) ([8230671](https://github.com/provusinc/quoting/commit/82306712d5aa24f9a24e7600eaa5a67a358076df))
- **psq-3908:** adding partner resource to ootb layout ([#1065](https://github.com/provusinc/quoting/issues/1065)) ([b3894ff](https://github.com/provusinc/quoting/commit/b3894ff44268a34e6bb5daafbf587947d14ac21a))
- **psq-3909:** rename delta menu item ([#1064](https://github.com/provusinc/quoting/issues/1064)) ([bae394c](https://github.com/provusinc/quoting/commit/bae394cb0f4a2c5bc4d1cae8e5c95a9761c0f350))
- **psq-4049:** grand total person count should be displayed with two decimal positions ([#1136](https://github.com/provusinc/quoting/issues/1136)) ([8a41b38](https://github.com/provusinc/quoting/commit/8a41b38bdc005db8db6f44738bdbfdb6e743cf27))
- **psq-4051:** scope discovery close button ([#1068](https://github.com/provusinc/quoting/issues/1068)) ([90f57fc](https://github.com/provusinc/quoting/commit/90f57fc9804a503e16cfe9866b3e0386162f1f9d))
- **psq-4051:** scope discovery close button ([#1080](https://github.com/provusinc/quoting/issues/1080)) ([d9d33c9](https://github.com/provusinc/quoting/commit/d9d33c9ce6ee8c4bf3c5f880187de08e8930c57e))
- **psq-4058:** added sequence to scope parameter query ([#1076](https://github.com/provusinc/quoting/issues/1076)) ([5284e3f](https://github.com/provusinc/quoting/commit/5284e3fbc4b6dea6775c3c44ddb14a2ecb6f4d9f))
- **psq-4061:** User is able to add values to Picklists copied from the scope parameter ([#1099](https://github.com/provusinc/quoting/issues/1099)) ([28e26ef](https://github.com/provusinc/quoting/commit/28e26ef6d9045d6d72a51a124de6b52f8cce91f0))
- **psq-4061:** link scope parameter fix ([#1070](https://github.com/provusinc/quoting/issues/1070)) ([f168546](https://github.com/provusinc/quoting/commit/f168546afb1efcab0424c84cf415baa71cde7691))
- **psq-4062:** refactored methods into cola support ([#1105](https://github.com/provusinc/quoting/issues/1105)) ([3d1ae70](https://github.com/provusinc/quoting/commit/3d1ae7023cfdb760c9f182dc8f18a58292410663))
- **psq-4081:** recurring cmp spelling required fix ([#1079](https://github.com/provusinc/quoting/issues/1079)) ([913951d](https://github.com/provusinc/quoting/commit/913951d6a34f0abf019575c08e9c8c331e5e9d07))
- **psq-4094:** User is able to enter Negative value to the Task Parameter Recommended Duration field ([#1090](https://github.com/provusinc/quoting/issues/1090)) ([02b797e](https://github.com/provusinc/quoting/commit/02b797eebcea771ab6bc84554da64fb1c4d4dfac))
- **psq-4100:** adjust hours errors on save ([#1095](https://github.com/provusinc/quoting/issues/1095)) ([8ff17aa](https://github.com/provusinc/quoting/commit/8ff17aa1884cc26d9673b5ea41c267c3d68ffbe0))
- **psq-4106:** milestone is not cloned successfully if Milestone added in quote ([#1124](https://github.com/provusinc/quoting/issues/1124)) ([fc2721b](https://github.com/provusinc/quoting/commit/fc2721b560a40ef69342a6db3466143e56bb567f))
- **psq-4107:** hide preferred resources button on Estimate after quote creation ([#1107](https://github.com/provusinc/quoting/issues/1107)) ([aae5ee3](https://github.com/provusinc/quoting/commit/aae5ee35f651c206a7b2205f009e3c946d778581))
- **psq-4131:** show fields in readonly when non-transient ([#1101](https://github.com/provusinc/quoting/issues/1101)) ([2f9a48c](https://github.com/provusinc/quoting/commit/2f9a48cfd0df79b328f2fa7824d7863913067477))
- **psq-4159:** adjust week and month period naming ([#1108](https://github.com/provusinc/quoting/issues/1108)) ([f5b4a8f](https://github.com/provusinc/quoting/commit/f5b4a8fa1b3dc70b000fcfd293280c63887d5182))
- **psq-4174:** varying total amount in weekday calendar ([#1122](https://github.com/provusinc/quoting/issues/1122)) ([323d62c](https://github.com/provusinc/quoting/commit/323d62cd0b768883a378ba1870ce96107796e9b4))
- **psq-4178:** fix error occurring in chrome dev console ([#1112](https://github.com/provusinc/quoting/issues/1112)) ([0e1d7fd](https://github.com/provusinc/quoting/commit/0e1d7fd1a99d3e6807510ab0c026c4f9d032fdc1))
- **psq-4180:** scope parameter link fix ([#1135](https://github.com/provusinc/quoting/issues/1135)) ([f9eb7c0](https://github.com/provusinc/quoting/commit/f9eb7c04c566d356e470e4adc965a1e6464f33a8))
- **psq-4182:** updated quoteitemcell trigger code for insert flow ([b7060b3](https://github.com/provusinc/quoting/commit/b7060b357c8a8b4e1db3342044b46236de33167e))
- **psq-4182:** updated quoteitemcell trigger code for insert flow ([#1121](https://github.com/provusinc/quoting/issues/1121)) ([691c479](https://github.com/provusinc/quoting/commit/691c479de91999b963ccf52e99356eaede895251))
- **psq-4203:** introduced hasDeletedRows flag ([#1127](https://github.com/provusinc/quoting/issues/1127)) ([5af350b](https://github.com/provusinc/quoting/commit/5af350bf3c13882900d8a60ad32ea464f4d8a4e1))
- **psq-4258:** supressing error message when product is empty ([#1128](https://github.com/provusinc/quoting/issues/1128)) ([03ae04b](https://github.com/provusinc/quoting/commit/03ae04b168b3f76c2b9840c0dda1e454b445bedc))
- **psq-4259:** expose serviceid field in quote detail tab ([#1132](https://github.com/provusinc/quoting/issues/1132)) ([949329a](https://github.com/provusinc/quoting/commit/949329aec16250addb54b16ebaae93f1ba7212eb))
- **psq-4300:** undo changes to match the different time period totals ([#1141](https://github.com/provusinc/quoting/issues/1141)) ([1faa2b5](https://github.com/provusinc/quoting/commit/1faa2b5111be36578b4053261149ac73d4ee5bfa))
- quote discount dialog doesn't load ([dff46ac](https://github.com/provusinc/quoting/commit/dff46ac4b5aa007f6fe4353f45f4046cbbaa1382))
- **quote grid:** scroll issue ([#1130](https://github.com/provusinc/quoting/issues/1130)) ([9161b02](https://github.com/provusinc/quoting/commit/9161b027860dc47fe1f270aa2f4255b1ee6a590e))
- **quote item cell:** period details were not being added to map in ([#1126](https://github.com/provusinc/quoting/issues/1126)) ([6e11f44](https://github.com/provusinc/quoting/commit/6e11f4455febbfc2e5f4e6625c70214c6d2b4a9b))
- recalculate quote total on discount save ([9362f99](https://github.com/provusinc/quoting/commit/9362f9919e7a84db565eb612d35a52a91222c3dc))
- resolve quote grid await issues ([#1109](https://github.com/provusinc/quoting/issues/1109)) ([3031965](https://github.com/provusinc/quoting/commit/3031965f286aba0589268e705759a1ee60a56ea3))
- **summaries:** calculate the net extended amount for all named ranges on save ([4d660bb](https://github.com/provusinc/quoting/commit/4d660bb2589570e8ed9201d5a2d1dc3f653186c4))
- time period alignment cannot have defaults ([bb4891c](https://github.com/provusinc/quoting/commit/bb4891ce24529d3795481e121c1606cd0ba46d43))
- user defined calendar references ([8655c29](https://github.com/provusinc/quoting/commit/8655c291cca8c87c8cdff0df238d1dc6b8bd1887))

### Reverts

- Revert "Revert "fix(psq-4106): milestone is not cloned successfully if Milestone added in quote (#1124)" (#1137)" ([ca625b5](https://github.com/provusinc/quoting/commit/ca625b5e6b0ffdcae3bdaf0ca07ab7a64109b213)), closes [#1124](https://github.com/provusinc/quoting/issues/1124) [#1137](https://github.com/provusinc/quoting/issues/1137)
- Revert "fix(psq-4182): updated quoteitemcell trigger code for insert flow (#1121)" (#1125) ([4fce87b](https://github.com/provusinc/quoting/commit/4fce87be1a37e1aa5304277acc40a159dbf277d8)), closes [#1121](https://github.com/provusinc/quoting/issues/1121) [#1125](https://github.com/provusinc/quoting/issues/1125)

## [2.32.0-next.16](https://github.com/provusinc/quoting/compare/v2.32.0-next.15...v2.32.0-next.16) (2022-06-27)

### Features

- **approval process:** introduce approval process data model ([#1146](https://github.com/provusinc/quoting/issues/1146)) ([f19ab05](https://github.com/provusinc/quoting/commit/f19ab05e1cc6aed42d7316634bded57c4f308096))

## [2.32.0-next.15](https://github.com/provusinc/quoting/compare/v2.32.0-next.14...v2.32.0-next.15) (2022-06-27)

### Features

- **psq-4070:** disallow add period functionality when Quote is Linked to an Estimate ([#1139](https://github.com/provusinc/quoting/issues/1139)) ([98cdefb](https://github.com/provusinc/quoting/commit/98cdefbc770ee4fc767f803556db25debaa5aa40))

## [2.32.0-next.14](https://github.com/provusinc/quoting/compare/v2.32.0-next.13...v2.32.0-next.14) (2022-06-25)

### Features

- remove erroneous custom label ([35d1876](https://github.com/provusinc/quoting/commit/35d1876564b30f12d365a32e25719c015ad0c23f))

## [2.32.0-next.13](https://github.com/provusinc/quoting/compare/v2.32.0-next.12...v2.32.0-next.13) (2022-06-24)

### Features

- **psq-3499:** quote comparison approver view ([#1140](https://github.com/provusinc/quoting/issues/1140)) ([172ac4d](https://github.com/provusinc/quoting/commit/172ac4d2dd12ab26f83ae0c3822c48a0e2284b2e))

## [2.32.0-next.12](https://github.com/provusinc/quoting/compare/v2.32.0-next.11...v2.32.0-next.12) (2022-06-24)

### Features

- add support for period named ranges ([7a56ce3](https://github.com/provusinc/quoting/commit/7a56ce394c3d4eb8f4c465a380c52111b9009eeb))
- **approvals:** added new submit for approval dialog ([#1134](https://github.com/provusinc/quoting/issues/1134)) ([ed83550](https://github.com/provusinc/quoting/commit/ed835505eb8195f5bd1ef31d7404798b6781fea4))

### Bug Fixes

- **custom labels:** ignore node modules to properly retrieve labels from org ([#1133](https://github.com/provusinc/quoting/issues/1133)) ([900c8a9](https://github.com/provusinc/quoting/commit/900c8a9c894dd459edd99791bf7c4300d8cb91be))
- do not run cola calculations if there are not cola rates ([b631caf](https://github.com/provusinc/quoting/commit/b631caf417ec62081582a4270b53e70f0babced7))
- **psq-4049:** grand total person count should be displayed with two decimal positions ([#1136](https://github.com/provusinc/quoting/issues/1136)) ([8a41b38](https://github.com/provusinc/quoting/commit/8a41b38bdc005db8db6f44738bdbfdb6e743cf27))
- **psq-4106:** milestone is not cloned successfully if Milestone added in quote ([#1124](https://github.com/provusinc/quoting/issues/1124)) ([fc2721b](https://github.com/provusinc/quoting/commit/fc2721b560a40ef69342a6db3466143e56bb567f))
- **psq-4180:** scope parameter link fix ([#1135](https://github.com/provusinc/quoting/issues/1135)) ([f9eb7c0](https://github.com/provusinc/quoting/commit/f9eb7c04c566d356e470e4adc965a1e6464f33a8))
- **psq-4300:** undo changes to match the different time period totals ([#1141](https://github.com/provusinc/quoting/issues/1141)) ([1faa2b5](https://github.com/provusinc/quoting/commit/1faa2b5111be36578b4053261149ac73d4ee5bfa))
- recalculate quote total on discount save ([c7772fc](https://github.com/provusinc/quoting/commit/c7772fc121ea7e9cffb2825ad2698260cbbd7aa2))

### Reverts

- Revert "Revert "fix(psq-4106): milestone is not cloned successfully if Milestone added in quote (#1124)" (#1137)" ([ca625b5](https://github.com/provusinc/quoting/commit/ca625b5e6b0ffdcae3bdaf0ca07ab7a64109b213)), closes [#1124](https://github.com/provusinc/quoting/issues/1124) [#1137](https://github.com/provusinc/quoting/issues/1137)

### [2.31.2](https://github.com/provusinc/quoting/compare/v2.31.1...v2.31.2) (2022-06-17)

### Bug Fixes

- do not run cola calculations if there are not cola rates ([b631caf](https://github.com/provusinc/quoting/commit/b631caf417ec62081582a4270b53e70f0babced7))

### [2.31.1](https://github.com/provusinc/quoting/compare/v2.31.0...v2.31.1) (2022-06-14)

### Bug Fixes

- recalculate quote total on discount save ([c7772fc](https://github.com/provusinc/quoting/commit/c7772fc121ea7e9cffb2825ad2698260cbbd7aa2))

## [2.31.0](https://github.com/provusinc/quoting/compare/v2.30.0...v2.31.0) (2022-06-13)

### Features

- update release versions ([13154ab](https://github.com/provusinc/quoting/commit/13154ab79c2916cfa2fd1d97823bd19433a50cc8))

## [2.31.0-next.14](https://github.com/provusinc/quoting/compare/v2.31.0-next.13...v2.31.0-next.14) (2022-06-13)

### Bug Fixes

- **psq-3611:** fixing smoke test issues ([#1114](https://github.com/provusinc/quoting/issues/1114)) ([e3e84fc](https://github.com/provusinc/quoting/commit/e3e84fc18eb48089a2389f7d372c7adaa0d803fd))

## [2.31.0-next.13](https://github.com/provusinc/quoting/compare/v2.31.0-next.12...v2.31.0-next.13) (2022-06-13)

### Bug Fixes

- **psq-4107:** hide preferred resources button on Estimate after quote creation ([#1107](https://github.com/provusinc/quoting/issues/1107)) ([aae5ee3](https://github.com/provusinc/quoting/commit/aae5ee35f651c206a7b2205f009e3c946d778581))

## [2.31.0-next.12](https://github.com/provusinc/quoting/compare/v2.31.0-next.11...v2.31.0-next.12) (2022-06-13)

### Bug Fixes

- quote discount dialog doesn't load ([dff46ac](https://github.com/provusinc/quoting/commit/dff46ac4b5aa007f6fe4353f45f4046cbbaa1382))

## [2.31.0-next.11](https://github.com/provusinc/quoting/compare/v2.31.0-next.10...v2.31.0-next.11) (2022-06-13)

### Features

- **cola:** auto apply cola rates to the quote on add/remove ([8191b2f](https://github.com/provusinc/quoting/commit/8191b2f694ec48208a64298e39fa0483ad49ac0a))
- **cola:** auto apply cola rates to the quote on add/remove ([b49d399](https://github.com/provusinc/quoting/commit/b49d39948e8dad147536f067307b34d7600e8eb3))
- **cola:** auto apply cola rates to the quote on add/remove ([c4fd843](https://github.com/provusinc/quoting/commit/c4fd8436ea66c98a8547103580c81c20e76490aa))
- **cola:** auto apply cola rates to the quote on add/remove ([c8311d6](https://github.com/provusinc/quoting/commit/c8311d6b5f5cc4216b69b9e3ef947291cd49213b))
- **cola:** auto apply cola rates to the quote on add/remove ([e153220](https://github.com/provusinc/quoting/commit/e1532206534c485f6b237cda29e386ed5f6c0177))

### Bug Fixes

- calculate effective discount for markup amount type ([#1110](https://github.com/provusinc/quoting/issues/1110)) ([6b3cecc](https://github.com/provusinc/quoting/commit/6b3ceccd3f2402733cdfea4340d311e6ec9a5ec8))
- **psq-4159:** adjust week and month period naming ([#1108](https://github.com/provusinc/quoting/issues/1108)) ([f5b4a8f](https://github.com/provusinc/quoting/commit/f5b4a8fa1b3dc70b000fcfd293280c63887d5182))
- **psq-4178:** fix error occurring in chrome dev console ([#1112](https://github.com/provusinc/quoting/issues/1112)) ([0e1d7fd](https://github.com/provusinc/quoting/commit/0e1d7fd1a99d3e6807510ab0c026c4f9d032fdc1))
- resolve quote grid await issues ([#1109](https://github.com/provusinc/quoting/issues/1109)) ([3031965](https://github.com/provusinc/quoting/commit/3031965f286aba0589268e705759a1ee60a56ea3))

## [2.31.0-next.10](https://github.com/provusinc/quoting/compare/v2.31.0-next.9...v2.31.0-next.10) (2022-06-10)

### Features

- **psq-4055:** user is not able to see Success message after save ([13f1c50](https://github.com/provusinc/quoting/commit/13f1c506ed68db58a50b9c2b88660435d8c36ec4))

### Bug Fixes

- **psq-3611:** fix for task parameter not getting cloned when task is… ([#1077](https://github.com/provusinc/quoting/issues/1077)) ([b5a656d](https://github.com/provusinc/quoting/commit/b5a656d552c69aa8d7b29bbd0112c86eecead07b))
- **psq-4062:** refactored methods into cola support ([#1105](https://github.com/provusinc/quoting/issues/1105)) ([3d1ae70](https://github.com/provusinc/quoting/commit/3d1ae7023cfdb760c9f182dc8f18a58292410663))

## [2.31.0-next.9](https://github.com/provusinc/quoting/compare/v2.31.0-next.8...v2.31.0-next.9) (2022-06-08)

### Features

- **trigger build:** release the split resource feature permanently ([768c1ac](https://github.com/provusinc/quoting/commit/768c1ac486f35296d790236090c0f3b46c881d5a))

### Bug Fixes

- change experimental features language to beta features ([904a321](https://github.com/provusinc/quoting/commit/904a3216a3ea177a5afa93037dfa202f94f1823a))
- **psq-3455:** scope param duplication ([#1102](https://github.com/provusinc/quoting/issues/1102)) ([481ebf1](https://github.com/provusinc/quoting/commit/481ebf196fe75ad1fb719d318a9b970d0344eb13))

## [2.31.0-next.8](https://github.com/provusinc/quoting/compare/v2.31.0-next.7...v2.31.0-next.8) (2022-06-08)

### Features

- **estimate template:** api for copying and resequencing tasks, activities, activity groups ([#1067](https://github.com/provusinc/quoting/issues/1067)) ([36fe71b](https://github.com/provusinc/quoting/commit/36fe71bd78d2a360699815f9c3111237b246ee44))

## [2.31.0-next.7](https://github.com/provusinc/quoting/compare/v2.31.0-next.6...v2.31.0-next.7) (2022-06-08)

### Features

- **psq-3562:** added sync to quote button on estimate tab ([#1098](https://github.com/provusinc/quoting/issues/1098)) ([0fe2497](https://github.com/provusinc/quoting/commit/0fe24973b567228251681acece57c5c78d25cb64))

### Bug Fixes

- **psq-4061:** User is able to add values to Picklists copied from the scope parameter ([#1099](https://github.com/provusinc/quoting/issues/1099)) ([28e26ef](https://github.com/provusinc/quoting/commit/28e26ef6d9045d6d72a51a124de6b52f8cce91f0))
- **psq-4131:** show fields in readonly when non-transient ([#1101](https://github.com/provusinc/quoting/issues/1101)) ([2f9a48c](https://github.com/provusinc/quoting/commit/2f9a48cfd0df79b328f2fa7824d7863913067477))

## [2.31.0-next.6](https://github.com/provusinc/quoting/compare/v2.31.0-next.5...v2.31.0-next.6) (2022-06-08)

### Bug Fixes

- **cola rates:** conditionally disable cola rate actions ([#1097](https://github.com/provusinc/quoting/issues/1097)) ([b0098a5](https://github.com/provusinc/quoting/commit/b0098a5f37c86f7ac3cfec547ed89766a3ffa376))

## [2.31.0-next.5](https://github.com/provusinc/quoting/compare/v2.31.0-next.4...v2.31.0-next.5) (2022-06-07)

### Features

- **trigger build:** cleanup time periods alignment references ([c20e1b5](https://github.com/provusinc/quoting/commit/c20e1b5bea7949599e8e7e5c644e914bc356efed))

### Bug Fixes

- add permission for is transient flag ([58e8a30](https://github.com/provusinc/quoting/commit/58e8a305fc086b5d1eb800ffd8b4077b10fbf398))
- **contingencie:** multiple add-on bugs related to baseExtendedAmount field ([#1092](https://github.com/provusinc/quoting/issues/1092)) ([b84a7bb](https://github.com/provusinc/quoting/commit/b84a7bbdd0f1ad1c92501df7526aab71c3e37d3d))
- **psq-3905:** changes for activity and tasks when split resource roles defined ([#1089](https://github.com/provusinc/quoting/issues/1089)) ([648fe84](https://github.com/provusinc/quoting/commit/648fe844449b9edf0065c1650fbe692f5c4b377b)), closes [#1081](https://github.com/provusinc/quoting/issues/1081)
- **psq-3907:** use css style hack to show overflow ([#1093](https://github.com/provusinc/quoting/issues/1093)) ([8230671](https://github.com/provusinc/quoting/commit/82306712d5aa24f9a24e7600eaa5a67a358076df))
- **psq-4061:** link scope parameter fix ([#1070](https://github.com/provusinc/quoting/issues/1070)) ([f168546](https://github.com/provusinc/quoting/commit/f168546afb1efcab0424c84cf415baa71cde7691))
- **psq-4094:** User is able to enter Negative value to the Task Parameter Recommended Duration field ([#1090](https://github.com/provusinc/quoting/issues/1090)) ([02b797e](https://github.com/provusinc/quoting/commit/02b797eebcea771ab6bc84554da64fb1c4d4dfac))
- **psq-4100:** adjust hours errors on save ([#1095](https://github.com/provusinc/quoting/issues/1095)) ([8ff17aa](https://github.com/provusinc/quoting/commit/8ff17aa1884cc26d9673b5ea41c267c3d68ffbe0))
- **summaries:** calculate the net extended amount for all named ranges on save ([4d660bb](https://github.com/provusinc/quoting/commit/4d660bb2589570e8ed9201d5a2d1dc3f653186c4))
- time period alignment cannot have defaults ([bb4891c](https://github.com/provusinc/quoting/commit/bb4891ce24529d3795481e121c1606cd0ba46d43))
- user defined calendar references ([8655c29](https://github.com/provusinc/quoting/commit/8655c291cca8c87c8cdff0df238d1dc6b8bd1887))

## [2.31.0-next.4](https://github.com/provusinc/quoting/compare/v2.31.0-next.3...v2.31.0-next.4) (2022-06-07)

### Features

- **psq-2915:** weekday calendar alignment ([#1072](https://github.com/provusinc/quoting/issues/1072)) ([d21e55f](https://github.com/provusinc/quoting/commit/d21e55ffec0a5fdc3154db6c239f3739b192c43a))

### Bug Fixes

- **psq-1654:** sorted summary tab resource role ([#1078](https://github.com/provusinc/quoting/issues/1078)) ([1550ba6](https://github.com/provusinc/quoting/commit/1550ba6625c6336cee0aa6bce2cd5844b62cc655))

## [2.31.0-next.3](https://github.com/provusinc/quoting/compare/v2.31.0-next.2...v2.31.0-next.3) (2022-06-07)

### Features

- **psq-3910:** global rate must exist at the quote level ([#1081](https://github.com/provusinc/quoting/issues/1081)) ([d6f0a1e](https://github.com/provusinc/quoting/commit/d6f0a1e2c3f666d7cbdf42a0a2f3633b9c651958))

### Bug Fixes

- **cola adjustment:** show error message after data loads ([#1082](https://github.com/provusinc/quoting/issues/1082)) ([5208fa7](https://github.com/provusinc/quoting/commit/5208fa7ea55eff026a0fb81bc779e96e2ea9b247))
- **psq-3808:** incorrect cola cost calculation ([#1084](https://github.com/provusinc/quoting/issues/1084)) ([cdef593](https://github.com/provusinc/quoting/commit/cdef593db03050a645241c943e84c16166d99ff7))
- **psq-3852:** cola adjustments not calculated for country/state/city ([#1083](https://github.com/provusinc/quoting/issues/1083)) ([f13db71](https://github.com/provusinc/quoting/commit/f13db7133d62cf776551e07869660fc29b927743))
- **psq-3904:** hide activities menu when no estimate linked ([#1075](https://github.com/provusinc/quoting/issues/1075)) ([f43fef4](https://github.com/provusinc/quoting/commit/f43fef4a5276305cffd2d73640afedb5c8604917))
- **psq-4051:** scope discovery close button ([#1080](https://github.com/provusinc/quoting/issues/1080)) ([d9d33c9](https://github.com/provusinc/quoting/commit/d9d33c9ce6ee8c4bf3c5f880187de08e8930c57e))
- **psq-4058:** added sequence to scope parameter query ([#1076](https://github.com/provusinc/quoting/issues/1076)) ([5284e3f](https://github.com/provusinc/quoting/commit/5284e3fbc4b6dea6775c3c44ddb14a2ecb6f4d9f))
- **psq-4081:** recurring cmp spelling required fix ([#1079](https://github.com/provusinc/quoting/issues/1079)) ([913951d](https://github.com/provusinc/quoting/commit/913951d6a34f0abf019575c08e9c8c331e5e9d07))

## [2.31.0-next.2](https://github.com/provusinc/quoting/compare/v2.31.0-next.1...v2.31.0-next.2) (2022-06-01)

### Bug Fixes

- **psq-4051:** scope discovery close button ([#1068](https://github.com/provusinc/quoting/issues/1068)) ([90f57fc](https://github.com/provusinc/quoting/commit/90f57fc9804a503e16cfe9866b3e0386162f1f9d))

## [2.31.0-next.1](https://github.com/provusinc/quoting/compare/v2.30.0...v2.31.0-next.1) (2022-06-01)

### Features

- **trigger build:** revert field change ([5a4f3ee](https://github.com/provusinc/quoting/commit/5a4f3ee0a31a0f85de4bd9a05498502d10bcf6bf))

### Bug Fixes

- **psq-3908:** adding partner resource to ootb layout ([#1065](https://github.com/provusinc/quoting/issues/1065)) ([b3894ff](https://github.com/provusinc/quoting/commit/b3894ff44268a34e6bb5daafbf587947d14ac21a))
- **psq-3909:** rename delta menu item ([#1064](https://github.com/provusinc/quoting/issues/1064)) ([bae394c](https://github.com/provusinc/quoting/commit/bae394cb0f4a2c5bc4d1cae8e5c95a9761c0f350))

## [2.30.0](https://github.com/provusinc/quoting/compare/v2.29.0...v2.30.0) (2022-05-31)

### Features

- **[psq]-3610:** enable ability to add year periods to quote ([#1050](https://github.com/provusinc/quoting/issues/1050)) ([255bd14](https://github.com/provusinc/quoting/commit/255bd146effb977947a36b33841ce0049bce2664))
- **add periods:** added validation for the add periods flow for pmax ([#1002](https://github.com/provusinc/quoting/issues/1002)) ([3629d3c](https://github.com/provusinc/quoting/commit/3629d3c935d8e80de4a88347dd809fa857c6dd91))
- **psq-2257:** quote level cola rates by location modal ([#1015](https://github.com/provusinc/quoting/issues/1015)) ([37653db](https://github.com/provusinc/quoting/commit/37653dbea9365255532ca6b0a81d105557e190a8))
- **psq-2613:** activities & tasks resource role context menu option ([#992](https://github.com/provusinc/quoting/issues/992)) ([b66174e](https://github.com/provusinc/quoting/commit/b66174e11ad16348ff349b23c81cd6a712ff385a))
- **psq-299:** ability to source resources from a partner ([#1043](https://github.com/provusinc/quoting/issues/1043)) ([ac664da](https://github.com/provusinc/quoting/commit/ac664dacb077117caf66b018b886c049dcc9875c))
- **PSQ-3382:** Make estimate read only when de-linked from quote ([#1005](https://github.com/provusinc/quoting/issues/1005)) ([368e850](https://github.com/provusinc/quoting/commit/368e85008b4d037b722b55102c237f95e5657e6e))
- **psq-3421:** changes for calculating total amount for task ([#1033](https://github.com/provusinc/quoting/issues/1033)) ([b85d8bb](https://github.com/provusinc/quoting/commit/b85d8bb7581e8226526a44804788efb746448420))
- **psq-3542:** close button moved to last ([#1049](https://github.com/provusinc/quoting/issues/1049)) ([b83b222](https://github.com/provusinc/quoting/commit/b83b2224346821351123a50d3f51f35ddfeb0761))
- **psq-3608:** number of periods added not correct ([#1020](https://github.com/provusinc/quoting/issues/1020)) ([8781374](https://github.com/provusinc/quoting/commit/8781374850c0e04ef6a5140993c5ccf7eceab841))
- **psq-3700:** user is able to save recurring hou ([#1054](https://github.com/provusinc/quoting/issues/1054)) ([f901ed3](https://github.com/provusinc/quoting/commit/f901ed3f213b6e2fdded5ae8582ebd5f2400c9e3))
- **recurring periods:** fixed NaN problem in parsing the row ([#1009](https://github.com/provusinc/quoting/issues/1009)) ([9c7568c](https://github.com/provusinc/quoting/commit/9c7568cbcdbc3c05d02cd8e5efdfb94d10b4b793))
- revert field name change ([d06e4fc](https://github.com/provusinc/quoting/commit/d06e4fcbd604ffd95705d9f059cc1fca0fdc61dd))
- **trigger build:** revert label APi name changes ([08de93e](https://github.com/provusinc/quoting/commit/08de93e2720d757048cfec027de8eafc7889f844))

### Bug Fixes

- add message service handler back to estimate flexipage ([afa032f](https://github.com/provusinc/quoting/commit/afa032f8c691edfc3eab1890b832cf6ba7635393))
- check for missing global rates before attempting to copy to the quote ([0968529](https://github.com/provusinc/quoting/commit/0968529c573a3992bce1584271c40ca74ce63a26))
- cleanup padding in cola dialog ([44d71ea](https://github.com/provusinc/quoting/commit/44d71ea987e29438ed04006030ad7172f158763f))
- **cola calcs:** fix the compound rate calculation ([#1025](https://github.com/provusinc/quoting/issues/1025)) ([f3a6274](https://github.com/provusinc/quoting/commit/f3a6274180a42c468bbf013f3828773eda9d75d9))
- **cola rates:** fixed cola rate header ([#1027](https://github.com/provusinc/quoting/issues/1027)) ([c85b289](https://github.com/provusinc/quoting/commit/c85b289b367169895459dd95a70b3f8d4e3ad15c))
- **cola worksheet:** fixed root cause of undefined error for costs by year ([#1021](https://github.com/provusinc/quoting/issues/1021)) ([bfd51ed](https://github.com/provusinc/quoting/commit/bfd51eda079d29d32db52a71780556ac5580495c))
- correct null pointer issue on saving wuotes ([49af419](https://github.com/provusinc/quoting/commit/49af4191ec9a2dd4069100f91213561963e9a5a5))
- **delink estimate:** reset columnsByName when we delink ([#1047](https://github.com/provusinc/quoting/issues/1047)) ([b68f3f9](https://github.com/provusinc/quoting/commit/b68f3f983244e3e4e4cd4dcb25b0a154b8b3d263))
- fix the cola calculation for the correct compounding interest ([0e4385e](https://github.com/provusinc/quoting/commit/0e4385e6cd1fb2b93c47fdc6a9c4853cdf3370c5))
- fix timing issues with dialog service ([9df1d79](https://github.com/provusinc/quoting/commit/9df1d79caa115e5e0e8400ff4efc3b4cfe4a98ae))
- **psq-1600:** clear task param values on data type changes ([#1006](https://github.com/provusinc/quoting/issues/1006)) ([dcd2414](https://github.com/provusinc/quoting/commit/dcd24149bb19f8f5733a58ef816e285a7ac21f1c))
- **psq-2949:** task parameter multiplier in decimal numbers are truncated/round-up in to two decimal places ([#1055](https://github.com/provusinc/quoting/issues/1055)) ([ca620dd](https://github.com/provusinc/quoting/commit/ca620dde66339a5a3c250cddb0c06d98bab2a5c7))
- **psq-3455:** param value row duplication ([#1036](https://github.com/provusinc/quoting/issues/1036)) ([979ff2f](https://github.com/provusinc/quoting/commit/979ff2fdb4e36949b52f1b8895ab15a2daf95310))
- **psq-3456:** add minimum height to scope param dialog ([#996](https://github.com/provusinc/quoting/issues/996)) ([cec5552](https://github.com/provusinc/quoting/commit/cec5552d454cd93291f7e2473f5257a6156b402a))
- **psq-3456:** use css style hack to show overflow ([#1010](https://github.com/provusinc/quoting/issues/1010)) ([54d1465](https://github.com/provusinc/quoting/commit/54d1465c4651529d2d646ed82e2177c09b92b5d3))
- **psq-3458:** From to To values not maintained ([#1039](https://github.com/provusinc/quoting/issues/1039)) ([02a656f](https://github.com/provusinc/quoting/commit/02a656f5fc0939b751fb6069803885fcad32b691))
- **psq-3513:** Estimate -> Quote: User is not able to create Quote from Estimate ([#1041](https://github.com/provusinc/quoting/issues/1041)) ([71741ea](https://github.com/provusinc/quoting/commit/71741eabb20d072718acf4bbb1d26e0f287d2963)), closes [#1050](https://github.com/provusinc/quoting/issues/1050)
- **psq-3514:** hide roles with no duration in preferred resources ([#999](https://github.com/provusinc/quoting/issues/999)) ([718d4df](https://github.com/provusinc/quoting/commit/718d4dfb2ec12bc73efaceda91ef24e4a960d112))
- **psq-3521:** sorted sequence of resource roles ([#998](https://github.com/provusinc/quoting/issues/998)) ([8b495b6](https://github.com/provusinc/quoting/commit/8b495b662a895c08b465990badde4687d63b1ba7))
- **psq-3529:** New Quote button enabled even if a quote is associated ([#997](https://github.com/provusinc/quoting/issues/997)) ([8a8c9f3](https://github.com/provusinc/quoting/commit/8a8c9f34b47455cfd7fe76d026ab35ff614dbd0a))
- **psq-3543:** remove rename addon footer actions gap ([#995](https://github.com/provusinc/quoting/issues/995)) ([6ae2869](https://github.com/provusinc/quoting/commit/6ae286922273cb66b95eb6b0bd805600a30391e3))
- **psq-3549:** resource role names blank on new estimate template ([#1000](https://github.com/provusinc/quoting/issues/1000)) ([efd9694](https://github.com/provusinc/quoting/commit/efd96948fa90ffe50081dde8ba596d0251ad21c2))
- **psq-3553:** fix for discount calculated on change instead of tab out ([#1038](https://github.com/provusinc/quoting/issues/1038)) ([7468029](https://github.com/provusinc/quoting/commit/74680292a4d8fc2acfc7d564e4be570f59b45a46))
- **psq-3555:** require scope param data type ([#1014](https://github.com/provusinc/quoting/issues/1014)) ([e13b68e](https://github.com/provusinc/quoting/commit/e13b68e0c91e8deb12c7fb5c26cece5b07b14cfe))
- **psq-3576:** code changes for split roles sync to quote ([#1045](https://github.com/provusinc/quoting/issues/1045)) ([0814bd6](https://github.com/provusinc/quoting/commit/0814bd6436bdfc356a97ea252f9d60ea3783c0f1))
- **psq-3591:** remove opportunity link for scenario quote ([#1003](https://github.com/provusinc/quoting/issues/1003)) ([b0b8fde](https://github.com/provusinc/quoting/commit/b0b8fde18b25ab2f884770e84bc18c63c960911e))
- **psq-3595:** swap the quote reference on the estimate post clone ([#1046](https://github.com/provusinc/quoting/issues/1046)) ([16e7f4a](https://github.com/provusinc/quoting/commit/16e7f4a67df2d35542f27858ac55e32b57eeeaf1))
- **psq-3595:** user is not able to make scenario primary ([#1004](https://github.com/provusinc/quoting/issues/1004)) ([8438a71](https://github.com/provusinc/quoting/commit/8438a714f5b92014a01dfcebb3247e7d6fd2a3f8))
- **psq-3602:** fix for resource role not populating when task is cloned ([#1034](https://github.com/provusinc/quoting/issues/1034)) ([bd17721](https://github.com/provusinc/quoting/commit/bd17721cfeddcff4f517eeee1025a3838912a34a))
- **psq-3602:** fixed for guidance not populating when task is cloned ([#1024](https://github.com/provusinc/quoting/issues/1024)) ([6b2687d](https://github.com/provusinc/quoting/commit/6b2687dcdda46dd7c947fc7ebaa9b88c55277940))
- **psq-3612:** updated cola adjustment worksheet header label ([#1001](https://github.com/provusinc/quoting/issues/1001)) ([4bceaee](https://github.com/provusinc/quoting/commit/4bceaee3b09bc6309c96c4f929ef5d5f30446152))
- **psq-3620:** Total Estimated Amount is not populated after Select/Save preferred resources ([#1007](https://github.com/provusinc/quoting/issues/1007)) ([5da2805](https://github.com/provusinc/quoting/commit/5da280503d44665de23a21b7da7bc9d61ebc0837))
- **psq-3621:** Allowed Values are separated by ',' ([#1011](https://github.com/provusinc/quoting/issues/1011)) ([cc4b625](https://github.com/provusinc/quoting/commit/cc4b625a3420747115d4c3cd9234272a5b43f937))
- **psq-3624:** copy linked scope param name to task param ([#1029](https://github.com/provusinc/quoting/issues/1029)) ([c5484bc](https://github.com/provusinc/quoting/commit/c5484bcea6a12527a7329db99a8b551cb1882c15))
- **psq-3625:** use linked icon when scope parameter is selected ([#1030](https://github.com/provusinc/quoting/issues/1030)) ([7c4065f](https://github.com/provusinc/quoting/commit/7c4065f233190804e0c8befa3515b3bc919fee3b))
- **psq-3626:** User is able to see Guidance as “See Referenced Scope Parameter” only after save ([#1035](https://github.com/provusinc/quoting/issues/1035)) ([e6a87b5](https://github.com/provusinc/quoting/commit/e6a87b5a154408971a5a386b3fdc887e90e8c8b6))
- **psq-3627:** read-only param value fields when scope param is linked ([#1031](https://github.com/provusinc/quoting/issues/1031)) ([962b780](https://github.com/provusinc/quoting/commit/962b7802df5444527cac251db0b16023d5e4bdb3))
- **psq-3628:** update task parameter value creation flow ([#1037](https://github.com/provusinc/quoting/issues/1037)) ([25b73b4](https://github.com/provusinc/quoting/commit/25b73b42929e527d4c84c2955cf2a0d414935f8d))
- **psq-3628:** update task parameter value creation to trigger ([#1044](https://github.com/provusinc/quoting/issues/1044)) ([dda03df](https://github.com/provusinc/quoting/commit/dda03dfea6b54b939c3e2d61e38422bd144db40f))
- **psq-3629:** changed columns name ([#1023](https://github.com/provusinc/quoting/issues/1023)) ([208f974](https://github.com/provusinc/quoting/commit/208f974b8a67386e83f64603599e1851e1d1a56d))
- **psq-3773:** tooltip message not as acceptance ([#1022](https://github.com/provusinc/quoting/issues/1022)) ([cf1dd46](https://github.com/provusinc/quoting/commit/cf1dd46390c0796183d68f4064bcc5f4cb106272))
- **psq-3774:** hide apply cola if there are no cola rates ([#1028](https://github.com/provusinc/quoting/issues/1028)) ([a3c41ca](https://github.com/provusinc/quoting/commit/a3c41ca48d19c9b70d5f264c54de26c69f995878))
- **psq-3775:** provide error message for no cola adjustments ([#1032](https://github.com/provusinc/quoting/issues/1032)) ([de38989](https://github.com/provusinc/quoting/commit/de38989419839b037e552a52ed26c3d5f690cea0))
- **psq-3783:** preferred resources showing rates from other cards ([#1026](https://github.com/provusinc/quoting/issues/1026)) ([a6251e1](https://github.com/provusinc/quoting/commit/a6251e1ecabd3622280589a9bd88b73a7d7aec6d))
- **psq-3806:** rate conversion factor dialog does not load sometimes when opened ([#1051](https://github.com/provusinc/quoting/issues/1051)) ([c13eac4](https://github.com/provusinc/quoting/commit/c13eac4698b5c969ed62b8fdc9ee643fa015acb6))
- **psq-3844:** dialogue box close on save ([#1040](https://github.com/provusinc/quoting/issues/1040)) ([414fb93](https://github.com/provusinc/quoting/commit/414fb93da2d26ddb09a5fa36c7299de0098dffc4))
- **psq-3851:** match country/city for cola rates ([#1063](https://github.com/provusinc/quoting/issues/1063)) ([e757798](https://github.com/provusinc/quoting/commit/e7577982fc1b8a5b3b4738b446902eed50fb42cc))
- **psq-3876:** unable to save scope parameter values ([4b4ab23](https://github.com/provusinc/quoting/commit/4b4ab23d25f67a9f0e03c10ad13f8a06245c57c5))
- **psq-3876:** unable to save scope parameter values ([eb70c6c](https://github.com/provusinc/quoting/commit/eb70c6cb761a1189e1b483938a21e7a7f14a188c))
- **psq-38963:** fix for template id not populating when estimate is created ([#1056](https://github.com/provusinc/quoting/issues/1056)) ([3eca57c](https://github.com/provusinc/quoting/commit/3eca57cdb30d6f170b5abd5196b3d5f73ab8452d))
- **psq-3897:** rate conversion factor dialog does not load sometimes when opened ([#1053](https://github.com/provusinc/quoting/issues/1053)) ([1697f6f](https://github.com/provusinc/quoting/commit/1697f6f63cbaab412ac32b558d3aaea05251efe6))
- **psq-3900:** fixed override column name ([#1060](https://github.com/provusinc/quoting/issues/1060)) ([086ce24](https://github.com/provusinc/quoting/commit/086ce24d10f880f88b5c08c45725012043214098))
- **psq-3903:** fixed cancel button ([#1057](https://github.com/provusinc/quoting/issues/1057)) ([94ce9ca](https://github.com/provusinc/quoting/commit/94ce9ca784a32d1485309371dd563dc5aef98e10))
- **psq-3911:** rename menu to Cola Rates ([#1061](https://github.com/provusinc/quoting/issues/1061)) ([ec8f184](https://github.com/provusinc/quoting/commit/ec8f1843bbcdcc4a472a71fb1006aa9ffe27a483))
- remove CreateScenariosFromQuote\_\_c from permission set ([470a79a](https://github.com/provusinc/quoting/commit/470a79a38d506b7890fd9e1a902d0dc31459d7a9))
- remove current cost column and fix cola calc ([ceeba87](https://github.com/provusinc/quoting/commit/ceeba874e923be73205c0772900b86bbda1f54dc))
- remove product2externalid field ([71e62ad](https://github.com/provusinc/quoting/commit/71e62adc7e7a15bfd4171416568572f58b92e514))
- upgrade @salesforce-ux/design-system from 2.17.5 to 2.18.0 ([#1052](https://github.com/provusinc/quoting/issues/1052)) ([b1d2f55](https://github.com/provusinc/quoting/commit/b1d2f55faec5374759874ac72c8f8ef1b485c67f))

### Reverts

- Revert "feat: rename relationshal field for scope params" ([9a185a1](https://github.com/provusinc/quoting/commit/9a185a103b43c4c47e4729cd8e29adbcb2fb39f4))
- "refactor: remove the bind method from class function" ([b09dc8a](https://github.com/provusinc/quoting/commit/b09dc8af42c0dd8094979a2320b862de8bae8144))

## [2.30.0-next.21](https://github.com/provusinc/quoting/compare/v2.30.0-next.20...v2.30.0-next.21) (2022-05-30)

### Bug Fixes

- **psq-3876:** unable to save scope parameter values ([4b4ab23](https://github.com/provusinc/quoting/commit/4b4ab23d25f67a9f0e03c10ad13f8a06245c57c5))

## [2.30.0-next.20](https://github.com/provusinc/quoting/compare/v2.30.0-next.19...v2.30.0-next.20) (2022-05-30)

### Bug Fixes

- **psq-3876:** unable to save scope parameter values ([eb70c6c](https://github.com/provusinc/quoting/commit/eb70c6cb761a1189e1b483938a21e7a7f14a188c))
- **psq-38963:** fix for template id not populating when estimate is created ([#1056](https://github.com/provusinc/quoting/issues/1056)) ([3eca57c](https://github.com/provusinc/quoting/commit/3eca57cdb30d6f170b5abd5196b3d5f73ab8452d))

## [2.30.0-next.19](https://github.com/provusinc/quoting/compare/v2.30.0-next.18...v2.30.0-next.19) (2022-05-30)

### Features

- **psq-3700:** user is able to save recurring hou ([#1054](https://github.com/provusinc/quoting/issues/1054)) ([f901ed3](https://github.com/provusinc/quoting/commit/f901ed3f213b6e2fdded5ae8582ebd5f2400c9e3))

### Bug Fixes

- **psq-2949:** task parameter multiplier in decimal numbers are truncated/round-up in to two decimal places ([#1055](https://github.com/provusinc/quoting/issues/1055)) ([ca620dd](https://github.com/provusinc/quoting/commit/ca620dde66339a5a3c250cddb0c06d98bab2a5c7))
- **psq-3897:** rate conversion factor dialog does not load sometimes when opened ([#1053](https://github.com/provusinc/quoting/issues/1053)) ([1697f6f](https://github.com/provusinc/quoting/commit/1697f6f63cbaab412ac32b558d3aaea05251efe6))
- upgrade @salesforce-ux/design-system from 2.17.5 to 2.18.0 ([#1052](https://github.com/provusinc/quoting/issues/1052)) ([b1d2f55](https://github.com/provusinc/quoting/commit/b1d2f55faec5374759874ac72c8f8ef1b485c67f))

## [2.30.0-next.18](https://github.com/provusinc/quoting/compare/v2.30.0-next.17...v2.30.0-next.18) (2022-05-28)

### Features

- **[psq]-3610:** enable ability to add year periods to quote ([#1050](https://github.com/provusinc/quoting/issues/1050)) ([255bd14](https://github.com/provusinc/quoting/commit/255bd146effb977947a36b33841ce0049bce2664))

## [2.30.0-next.17](https://github.com/provusinc/quoting/compare/v2.30.0-next.16...v2.30.0-next.17) (2022-05-27)

### Bug Fixes

- **psq-3806:** rate conversion factor dialog does not load sometimes when opened ([#1051](https://github.com/provusinc/quoting/issues/1051)) ([c13eac4](https://github.com/provusinc/quoting/commit/c13eac4698b5c969ed62b8fdc9ee643fa015acb6))

## [2.30.0-next.16](https://github.com/provusinc/quoting/compare/v2.30.0-next.15...v2.30.0-next.16) (2022-05-27)

### Features

- **psq-3542:** close button moved to last ([#1049](https://github.com/provusinc/quoting/issues/1049)) ([b83b222](https://github.com/provusinc/quoting/commit/b83b2224346821351123a50d3f51f35ddfeb0761))

### Bug Fixes

- fix timing issues with dialog service ([9df1d79](https://github.com/provusinc/quoting/commit/9df1d79caa115e5e0e8400ff4efc3b4cfe4a98ae))
- **psq-3628:** update task parameter value creation to trigger ([#1044](https://github.com/provusinc/quoting/issues/1044)) ([dda03df](https://github.com/provusinc/quoting/commit/dda03dfea6b54b939c3e2d61e38422bd144db40f))

## [2.30.0-next.15](https://github.com/provusinc/quoting/compare/v2.30.0-next.14...v2.30.0-next.15) (2022-05-26)

### Bug Fixes

- **psq-3576:** code changes for split roles sync to quote ([#1045](https://github.com/provusinc/quoting/issues/1045)) ([0814bd6](https://github.com/provusinc/quoting/commit/0814bd6436bdfc356a97ea252f9d60ea3783c0f1))

## [2.30.0-next.14](https://github.com/provusinc/quoting/compare/v2.30.0-next.13...v2.30.0-next.14) (2022-05-26)

### Bug Fixes

- **delink estimate:** reset columnsByName when we delink ([#1047](https://github.com/provusinc/quoting/issues/1047)) ([b68f3f9](https://github.com/provusinc/quoting/commit/b68f3f983244e3e4e4cd4dcb25b0a154b8b3d263))

## [2.30.0-next.13](https://github.com/provusinc/quoting/compare/v2.30.0-next.12...v2.30.0-next.13) (2022-05-26)

### Bug Fixes

- **psq-3595:** swap the quote reference on the estimate post clone ([#1046](https://github.com/provusinc/quoting/issues/1046)) ([16e7f4a](https://github.com/provusinc/quoting/commit/16e7f4a67df2d35542f27858ac55e32b57eeeaf1))

## [2.30.0-next.12](https://github.com/provusinc/quoting/compare/v2.30.0-next.11...v2.30.0-next.12) (2022-05-25)

### Features

- **psq-299:** ability to source resources from a partner ([#1043](https://github.com/provusinc/quoting/issues/1043)) ([ac664da](https://github.com/provusinc/quoting/commit/ac664dacb077117caf66b018b886c049dcc9875c))

### Bug Fixes

- add message service handler back to estimate flexipage ([afa032f](https://github.com/provusinc/quoting/commit/afa032f8c691edfc3eab1890b832cf6ba7635393))
- **psq-3844:** dialogue box close on save ([#1040](https://github.com/provusinc/quoting/issues/1040)) ([414fb93](https://github.com/provusinc/quoting/commit/414fb93da2d26ddb09a5fa36c7299de0098dffc4))

## [2.30.0-next.11](https://github.com/provusinc/quoting/compare/v2.30.0-next.10...v2.30.0-next.11) (2022-05-25)

### Bug Fixes

- **psq-3458:** From to To values not maintained ([#1039](https://github.com/provusinc/quoting/issues/1039)) ([02a656f](https://github.com/provusinc/quoting/commit/02a656f5fc0939b751fb6069803885fcad32b691))
- **psq-3553:** fix for discount calculated on change instead of tab out ([#1038](https://github.com/provusinc/quoting/issues/1038)) ([7468029](https://github.com/provusinc/quoting/commit/74680292a4d8fc2acfc7d564e4be570f59b45a46))
- **psq-3626:** User is able to see Guidance as “See Referenced Scope Parameter” only after save ([#1035](https://github.com/provusinc/quoting/issues/1035)) ([e6a87b5](https://github.com/provusinc/quoting/commit/e6a87b5a154408971a5a386b3fdc887e90e8c8b6))

## [2.30.0-next.10](https://github.com/provusinc/quoting/compare/v2.30.0-next.9...v2.30.0-next.10) (2022-05-25)

### Features

- **psq-3421:** changes for calculating total amount for task ([#1033](https://github.com/provusinc/quoting/issues/1033)) ([b85d8bb](https://github.com/provusinc/quoting/commit/b85d8bb7581e8226526a44804788efb746448420))

### Bug Fixes

- **psq-3628:** update task parameter value creation flow ([#1037](https://github.com/provusinc/quoting/issues/1037)) ([25b73b4](https://github.com/provusinc/quoting/commit/25b73b42929e527d4c84c2955cf2a0d414935f8d))

## [2.30.0-next.9](https://github.com/provusinc/quoting/compare/v2.30.0-next.8...v2.30.0-next.9) (2022-05-25)

### Bug Fixes

- **psq-3455:** param value row duplication ([#1036](https://github.com/provusinc/quoting/issues/1036)) ([979ff2f](https://github.com/provusinc/quoting/commit/979ff2fdb4e36949b52f1b8895ab15a2daf95310))

## [2.30.0-next.8](https://github.com/provusinc/quoting/compare/v2.30.0-next.7...v2.30.0-next.8) (2022-05-24)

### Bug Fixes

- **psq-3602:** fix for resource role not populating when task is cloned ([#1034](https://github.com/provusinc/quoting/issues/1034)) ([bd17721](https://github.com/provusinc/quoting/commit/bd17721cfeddcff4f517eeee1025a3838912a34a))

## [2.30.0-next.7](https://github.com/provusinc/quoting/compare/v2.30.0-next.6...v2.30.0-next.7) (2022-05-24)

### Bug Fixes

- cleanup padding in cola dialog ([44d71ea](https://github.com/provusinc/quoting/commit/44d71ea987e29438ed04006030ad7172f158763f))

## [2.30.0-next.6](https://github.com/provusinc/quoting/compare/v2.30.0-next.5...v2.30.0-next.6) (2022-05-24)

### Features

- **psq-3608:** number of periods added not correct ([#1020](https://github.com/provusinc/quoting/issues/1020)) ([8781374](https://github.com/provusinc/quoting/commit/8781374850c0e04ef6a5140993c5ccf7eceab841))

### Bug Fixes

- **psq-3624:** copy linked scope param name to task param ([#1029](https://github.com/provusinc/quoting/issues/1029)) ([c5484bc](https://github.com/provusinc/quoting/commit/c5484bcea6a12527a7329db99a8b551cb1882c15))
- **psq-3625:** use linked icon when scope parameter is selected ([#1030](https://github.com/provusinc/quoting/issues/1030)) ([7c4065f](https://github.com/provusinc/quoting/commit/7c4065f233190804e0c8befa3515b3bc919fee3b))
- **psq-3627:** read-only param value fields when scope param is linked ([#1031](https://github.com/provusinc/quoting/issues/1031)) ([962b780](https://github.com/provusinc/quoting/commit/962b7802df5444527cac251db0b16023d5e4bdb3))
- **psq-3629:** changed columns name ([#1023](https://github.com/provusinc/quoting/issues/1023)) ([208f974](https://github.com/provusinc/quoting/commit/208f974b8a67386e83f64603599e1851e1d1a56d))
- **psq-3774:** hide apply cola if there are no cola rates ([#1028](https://github.com/provusinc/quoting/issues/1028)) ([a3c41ca](https://github.com/provusinc/quoting/commit/a3c41ca48d19c9b70d5f264c54de26c69f995878))
- **psq-3775:** provide error message for no cola adjustments ([#1032](https://github.com/provusinc/quoting/issues/1032)) ([de38989](https://github.com/provusinc/quoting/commit/de38989419839b037e552a52ed26c3d5f690cea0))
- **psq-3783:** preferred resources showing rates from other cards ([#1026](https://github.com/provusinc/quoting/issues/1026)) ([a6251e1](https://github.com/provusinc/quoting/commit/a6251e1ecabd3622280589a9bd88b73a7d7aec6d))

## [2.30.0-next.5](https://github.com/provusinc/quoting/compare/v2.30.0-next.4...v2.30.0-next.5) (2022-05-23)

### Bug Fixes

- remove current cost column and fix cola calc ([ceeba87](https://github.com/provusinc/quoting/commit/ceeba874e923be73205c0772900b86bbda1f54dc))

## [2.30.0-next.4](https://github.com/provusinc/quoting/compare/v2.30.0-next.3...v2.30.0-next.4) (2022-05-23)

### Features

- **psq-2613:** activities & tasks resource role context menu option ([#992](https://github.com/provusinc/quoting/issues/992)) ([b66174e](https://github.com/provusinc/quoting/commit/b66174e11ad16348ff349b23c81cd6a712ff385a))

### Bug Fixes

- **cola calcs:** fix the compound rate calculation ([#1025](https://github.com/provusinc/quoting/issues/1025)) ([f3a6274](https://github.com/provusinc/quoting/commit/f3a6274180a42c468bbf013f3828773eda9d75d9))
- **cola rates:** fixed cola rate header ([#1027](https://github.com/provusinc/quoting/issues/1027)) ([c85b289](https://github.com/provusinc/quoting/commit/c85b289b367169895459dd95a70b3f8d4e3ad15c))
- **cola worksheet:** fixed root cause of undefined error for costs by year ([#1021](https://github.com/provusinc/quoting/issues/1021)) ([bfd51ed](https://github.com/provusinc/quoting/commit/bfd51eda079d29d32db52a71780556ac5580495c))

## [2.30.0-next.3](https://github.com/provusinc/quoting/compare/v2.30.0-next.2...v2.30.0-next.3) (2022-05-23)

### Bug Fixes

- **psq-3602:** fixed for guidance not populating when task is cloned ([#1024](https://github.com/provusinc/quoting/issues/1024)) ([6b2687d](https://github.com/provusinc/quoting/commit/6b2687dcdda46dd7c947fc7ebaa9b88c55277940))

## [2.30.0-next.2](https://github.com/provusinc/quoting/compare/v2.30.0-next.1...v2.30.0-next.2) (2022-05-23)

### Features

- **psq-2257:** quote level cola rates by location modal ([#1015](https://github.com/provusinc/quoting/issues/1015)) ([37653db](https://github.com/provusinc/quoting/commit/37653dbea9365255532ca6b0a81d105557e190a8))

### Bug Fixes

- **psq-3521:** sorted sequence of resource roles ([#998](https://github.com/provusinc/quoting/issues/998)) ([8b495b6](https://github.com/provusinc/quoting/commit/8b495b662a895c08b465990badde4687d63b1ba7))
- **psq-3773:** tooltip message not as acceptance ([#1022](https://github.com/provusinc/quoting/issues/1022)) ([cf1dd46](https://github.com/provusinc/quoting/commit/cf1dd46390c0796183d68f4064bcc5f4cb106272))

## [2.30.0-next.1](https://github.com/provusinc/quoting/compare/v2.29.0...v2.30.0-next.1) (2022-05-20)

### Features

- **add periods:** added validation for the add periods flow for pmax ([#1002](https://github.com/provusinc/quoting/issues/1002)) ([3629d3c](https://github.com/provusinc/quoting/commit/3629d3c935d8e80de4a88347dd809fa857c6dd91))
- **PSQ-3382:** Make estimate read only when de-linked from quote ([#1005](https://github.com/provusinc/quoting/issues/1005)) ([368e850](https://github.com/provusinc/quoting/commit/368e85008b4d037b722b55102c237f95e5657e6e))
- **recurring periods:** fixed NaN problem in parsing the row ([#1009](https://github.com/provusinc/quoting/issues/1009)) ([9c7568c](https://github.com/provusinc/quoting/commit/9c7568cbcdbc3c05d02cd8e5efdfb94d10b4b793))
- **trigger build:** revert label APi name changes ([08de93e](https://github.com/provusinc/quoting/commit/08de93e2720d757048cfec027de8eafc7889f844))

### Bug Fixes

- check for missing global rates before attempting to copy to the quote ([0968529](https://github.com/provusinc/quoting/commit/0968529c573a3992bce1584271c40ca74ce63a26))
- correct null pointer issue on saving wuotes ([49af419](https://github.com/provusinc/quoting/commit/49af4191ec9a2dd4069100f91213561963e9a5a5))
- fix the cola calculation for the correct compounding interest ([0e4385e](https://github.com/provusinc/quoting/commit/0e4385e6cd1fb2b93c47fdc6a9c4853cdf3370c5))
- **psq-1600:** clear task param values on data type changes ([#1006](https://github.com/provusinc/quoting/issues/1006)) ([dcd2414](https://github.com/provusinc/quoting/commit/dcd24149bb19f8f5733a58ef816e285a7ac21f1c))
- **psq-3456:** add minimum height to scope param dialog ([#996](https://github.com/provusinc/quoting/issues/996)) ([cec5552](https://github.com/provusinc/quoting/commit/cec5552d454cd93291f7e2473f5257a6156b402a))
- **psq-3456:** use css style hack to show overflow ([#1010](https://github.com/provusinc/quoting/issues/1010)) ([54d1465](https://github.com/provusinc/quoting/commit/54d1465c4651529d2d646ed82e2177c09b92b5d3))
- **psq-3514:** hide roles with no duration in preferred resources ([#999](https://github.com/provusinc/quoting/issues/999)) ([718d4df](https://github.com/provusinc/quoting/commit/718d4dfb2ec12bc73efaceda91ef24e4a960d112))
- **psq-3529:** New Quote button enabled even if a quote is associated ([#997](https://github.com/provusinc/quoting/issues/997)) ([8a8c9f3](https://github.com/provusinc/quoting/commit/8a8c9f34b47455cfd7fe76d026ab35ff614dbd0a))
- **psq-3543:** remove rename addon footer actions gap ([#995](https://github.com/provusinc/quoting/issues/995)) ([6ae2869](https://github.com/provusinc/quoting/commit/6ae286922273cb66b95eb6b0bd805600a30391e3))
- **psq-3549:** resource role names blank on new estimate template ([#1000](https://github.com/provusinc/quoting/issues/1000)) ([efd9694](https://github.com/provusinc/quoting/commit/efd96948fa90ffe50081dde8ba596d0251ad21c2))
- **psq-3555:** require scope param data type ([#1014](https://github.com/provusinc/quoting/issues/1014)) ([e13b68e](https://github.com/provusinc/quoting/commit/e13b68e0c91e8deb12c7fb5c26cece5b07b14cfe))
- **psq-3591:** remove opportunity link for scenario quote ([#1003](https://github.com/provusinc/quoting/issues/1003)) ([b0b8fde](https://github.com/provusinc/quoting/commit/b0b8fde18b25ab2f884770e84bc18c63c960911e))
- **psq-3595:** user is not able to make scenario primary ([#1004](https://github.com/provusinc/quoting/issues/1004)) ([8438a71](https://github.com/provusinc/quoting/commit/8438a714f5b92014a01dfcebb3247e7d6fd2a3f8))
- **psq-3612:** updated cola adjustment worksheet header label ([#1001](https://github.com/provusinc/quoting/issues/1001)) ([4bceaee](https://github.com/provusinc/quoting/commit/4bceaee3b09bc6309c96c4f929ef5d5f30446152))
- **psq-3620:** Total Estimated Amount is not populated after Select/Save preferred resources ([#1007](https://github.com/provusinc/quoting/issues/1007)) ([5da2805](https://github.com/provusinc/quoting/commit/5da280503d44665de23a21b7da7bc9d61ebc0837))
- **psq-3621:** Allowed Values are separated by ',' ([#1011](https://github.com/provusinc/quoting/issues/1011)) ([cc4b625](https://github.com/provusinc/quoting/commit/cc4b625a3420747115d4c3cd9234272a5b43f937))
- remove CreateScenariosFromQuote\_\_c from permission set ([470a79a](https://github.com/provusinc/quoting/commit/470a79a38d506b7890fd9e1a902d0dc31459d7a9))
- remove product2externalid field ([71e62ad](https://github.com/provusinc/quoting/commit/71e62adc7e7a15bfd4171416568572f58b92e514))

### Reverts

- Revert "feat: rename relationshal field for scope params" ([9a185a1](https://github.com/provusinc/quoting/commit/9a185a103b43c4c47e4729cd8e29adbcb2fb39f4))
- "refactor: remove the bind method from class function" ([b09dc8a](https://github.com/provusinc/quoting/commit/b09dc8af42c0dd8094979a2320b862de8bae8144))

## [2.29.0](https://github.com/provusinc/quoting/compare/v2.28.2...v2.29.0) (2022-05-20)

### Features

- activate the contingency picklist value ([5f9d94f](https://github.com/provusinc/quoting/commit/5f9d94fab9fb5bd1b4328f214a001d2c71ca3ce9))

### Bug Fixes

- fix the cola calculation for the correct compounding interest ([31456f5](https://github.com/provusinc/quoting/commit/31456f5cd8479699fa6b700914fc71cde9bfd2dc))

### [2.28.2](https://github.com/provusinc/quoting/compare/v2.28.1...v2.28.2) (2022-05-20)

### Bug Fixes

- only consider cola for the service start year ([c7589f9](https://github.com/provusinc/quoting/commit/c7589f90c1cc382535b09720b92d345b3fc6a52f))

### [2.28.1](https://github.com/provusinc/quoting/compare/v2.28.0...v2.28.1) (2022-05-19)

### Bug Fixes

- remove validation for check params ([a6cca0f](https://github.com/provusinc/quoting/commit/a6cca0f61acfd2cfcd6fec34f9febe975690f66b))

## [2.28.0](https://github.com/provusinc/quoting/compare/v2.27.0...v2.28.0) (2022-05-19)

### Features

- **trigger build:** artifacts missing in managed package ([99e180e](https://github.com/provusinc/quoting/commit/99e180e1adb526a2f5bdc012c97bdff85321674a))

### Bug Fixes

- resolve issue with global cola rate cell edit ([fb7f986](https://github.com/provusinc/quoting/commit/fb7f986956bb6a525f4ffa9b22f6a5aa2d8f234c))

## [2.27.0](https://github.com/provusinc/quoting/compare/v2.26.0...v2.27.0) (2022-05-19)

### Features

- **recurring periods:** fixed NaN problem in parsing the row ([#1009](https://github.com/provusinc/quoting/issues/1009)) ([f76be07](https://github.com/provusinc/quoting/commit/f76be07e94ff5cc759d52b88e2487bb64cdab3fa))

## [2.26.0](https://github.com/provusinc/quoting/compare/v2.25.0...v2.26.0) (2022-05-17)

### Features

- trigger release ignoring semantic-version ([0fde408](https://github.com/provusinc/quoting/commit/0fde40872ecee70683f4d91694c331de78b3cb72))

### Reverts

- Revert "feat: trigger build - remove custom permissions" ([9bc9277](https://github.com/provusinc/quoting/commit/9bc9277c4fc28cabc6d82a1f105d9ece34c2c34e))

## [2.24.0](https://github.com/provusinc/quoting/compare/v2.23.1...v2.24.0) (2022-05-17)

### Features

- add missing flow ([dc6622e](https://github.com/provusinc/quoting/commit/dc6622e7cd9a580fc07a179c594eeead51298b86))
- **cola adjustment:** added api for adjusting cola rates and tests ([#947](https://github.com/provusinc/quoting/issues/947)) ([c64ca9c](https://github.com/provusinc/quoting/commit/c64ca9c62bb08040ecc3e027da63b146070582bd))
- **cola adjustment:** added api for adjusting cola rates and tests ([#937](https://github.com/provusinc/quoting/issues/937)) ([c4f21aa](https://github.com/provusinc/quoting/commit/c4f21aae8c63023ece54b31b35407191e24134ac))
- **cola adjustment:** added tests for adjust cola and global cola ([#948](https://github.com/provusinc/quoting/issues/948)) ([fffe47c](https://github.com/provusinc/quoting/commit/fffe47c548306efb8cfbf41eb0df8d5a4c074fb7))
- **delink estimate:** force view refresh and reload grid ([#988](https://github.com/provusinc/quoting/issues/988)) ([8f12179](https://github.com/provusinc/quoting/commit/8f12179af1910565a1e0de09d815be0399605d05))
- introduce a quick action component for consistent modal headers ([0bdba01](https://github.com/provusinc/quoting/commit/0bdba01772a73554983b395ef6d686113e82f4b9))
- move scope parameter id from task to task parameter value ([283a38b](https://github.com/provusinc/quoting/commit/283a38bb25d45df98c52b7d52d511774a043c29a))
- **pas-2918:** ability to link task and scope parameter templates ([268695a](https://github.com/provusinc/quoting/commit/268695a9afb08acfe3120e9757bc6d0f3d48f4a3))
- **psq-1528:** Make selection of a service product optional in an estimate template ([#928](https://github.com/provusinc/quoting/issues/928)) ([a625126](https://github.com/provusinc/quoting/commit/a625126398c26881ad852a5e227ab7ad38f21965))
- **psq-1977:** Ability to deep clone a quote ([#943](https://github.com/provusinc/quoting/issues/943)) ([7b290e5](https://github.com/provusinc/quoting/commit/7b290e56a7c30a1bec807ac5e0c8a569cdb5b9fe))
- **psq-2359:** sync estimate changes to quote ([#938](https://github.com/provusinc/quoting/issues/938)) ([f687181](https://github.com/provusinc/quoting/commit/f6871811e303a71e3dee463c884bd8aa6617ee93))
- **psq-2370:** view cola rates and calculation summaries on a quote ([#976](https://github.com/provusinc/quoting/issues/976)) ([4a769e2](https://github.com/provusinc/quoting/commit/4a769e266a694366c4ea242a78705e7850164414))
- **psq-2867:** ability to add new periods to the end of an existing quote ([#990](https://github.com/provusinc/quoting/issues/990)) ([7e55d81](https://github.com/provusinc/quoting/commit/7e55d8111945846e1275b63e9a4d78797c8ca150))
- **psq-2916:** scope parameter dialog improvements ([#953](https://github.com/provusinc/quoting/issues/953)) ([012752e](https://github.com/provusinc/quoting/commit/012752eeaba8f3039ce6607997c8eaa6e870e102))
- **psq-2916:** scope parameters ([#946](https://github.com/provusinc/quoting/issues/946)) ([3355e74](https://github.com/provusinc/quoting/commit/3355e74653070b879bdb0cc29a5c4c95b27b3825))
- **psq-2916:** scope parameters row addition should cast to number ([#957](https://github.com/provusinc/quoting/issues/957)) ([9987594](https://github.com/provusinc/quoting/commit/998759419b7e6807b57ed3b800b9ca7fb2f1de1a))
- **psq-2975:** show quote link in estimate header ([#972](https://github.com/provusinc/quoting/issues/972)) ([445c084](https://github.com/provusinc/quoting/commit/445c0843a77a671dc9fe9ff870298dadb7c019c0))
- **psq-2976:** hide new quote action in estimate ([#935](https://github.com/provusinc/quoting/issues/935)) ([02a45ff](https://github.com/provusinc/quoting/commit/02a45ff828fea98a23e6e52e6dd32e9d042865bf))
- **psq-2979:** scope discovery on estimate changes ([#968](https://github.com/provusinc/quoting/issues/968)) ([1b9bd55](https://github.com/provusinc/quoting/commit/1b9bd556607da7b32eb6a759871878f50f9b1fba))
- **psq-3061:** ability to copy a task and assign to roles ([#970](https://github.com/provusinc/quoting/issues/970)) ([17b47d1](https://github.com/provusinc/quoting/commit/17b47d142873acf5084cfcb966104416b893ae10))
- **psq-3179:** link a new primary quote to the opportunity of the previous quote ([#979](https://github.com/provusinc/quoting/issues/979)) ([49efc52](https://github.com/provusinc/quoting/commit/49efc526455c8fcb8b188cd3edf7dc1993968d5c))
- **psq-3351,psq-3352:** resource default fix ([#951](https://github.com/provusinc/quoting/issues/951)) ([451f96d](https://github.com/provusinc/quoting/commit/451f96d83c6be7d8231256551a64f67804998d48))
- **psq-3356:** introduce an estimate tab to the quote ([#941](https://github.com/provusinc/quoting/issues/941)) ([8d3979d](https://github.com/provusinc/quoting/commit/8d3979d86ed42f620431bd518857b7260386db65))
- **psq-3394:** copy the global cola rates to quote on quote creation ([#958](https://github.com/provusinc/quoting/issues/958)) ([9a69c20](https://github.com/provusinc/quoting/commit/9a69c208733293bac9659afecbf7c35511e00e1f))
- **psq-3441:** scope parameter dialog header separator ([#961](https://github.com/provusinc/quoting/issues/961)) ([38f202f](https://github.com/provusinc/quoting/commit/38f202f5d2b33558471d3e5ba4444f9069a864a9))
- **psq-366:** remove the logic around quote template ([#940](https://github.com/provusinc/quoting/issues/940)) ([55d9047](https://github.com/provusinc/quoting/commit/55d90475850853a4ade7e68a5f186d21ed20bca8))
- **recurring times:** ability to add recurring time to resources on a quote ([#984](https://github.com/provusinc/quoting/issues/984)) ([998c9a3](https://github.com/provusinc/quoting/commit/998c9a327aa9928a4dd7b9dcf0083d6cd23603f5))
- rename relationshal field for scope params ([ab097ce](https://github.com/provusinc/quoting/commit/ab097cede95b12574968a9a76172937c360db1b7))
- trigger build ([9f38d3c](https://github.com/provusinc/quoting/commit/9f38d3c659b1fd0640602c0354f62a2ab7368062))
- trigger build - remove custom permissions ([f7e1fd2](https://github.com/provusinc/quoting/commit/f7e1fd25a1b4620d1c64c8fc01d9f6616852ee90))
- trigger release ignoring semantic-version ([68ef66e](https://github.com/provusinc/quoting/commit/68ef66ecae1b59d6c074da110c9e324c1e33c392))

### Bug Fixes

- **cola rate:** remove active flag for cola rate sheets ([#982](https://github.com/provusinc/quoting/issues/982)) ([0a1bd01](https://github.com/provusinc/quoting/commit/0a1bd015a04d5133e5a71ae11d4e912efe126934))
- **cola rate:** remove active flag for cola rate sheets ([#986](https://github.com/provusinc/quoting/issues/986)) ([5a5332a](https://github.com/provusinc/quoting/commit/5a5332aae0b0f492d11b7dbe12d0ba992d3e0655))
- **flow-trigger:** $Prior_Value does not work in namespaced orgs ([661fd03](https://github.com/provusinc/quoting/commit/661fd03d822bdd62a8e346b2c65c1edd2e318213))
- **psq-2831:** User can add a resource which is not in Rate card ([#892](https://github.com/provusinc/quoting/issues/892)) ([19987e7](https://github.com/provusinc/quoting/commit/19987e7dd2af73df59c02632f5ebeb9d10745bc8)), closes [#902](https://github.com/provusinc/quoting/issues/902) [#900](https://github.com/provusinc/quoting/issues/900) [#886](https://github.com/provusinc/quoting/issues/886) [#886](https://github.com/provusinc/quoting/issues/886) [#900](https://github.com/provusinc/quoting/issues/900) [#905](https://github.com/provusinc/quoting/issues/905) [#905](https://github.com/provusinc/quoting/issues/905) [#860](https://github.com/provusinc/quoting/issues/860) [#906](https://github.com/provusinc/quoting/issues/906) [#901](https://github.com/provusinc/quoting/issues/901) [#901](https://github.com/provusinc/quoting/issues/901) [#860](https://github.com/provusinc/quoting/issues/860) [#906](https://github.com/provusinc/quoting/issues/906)
- **psq-2867:** quote date range spanning across month boundary should generate two periods ([#991](https://github.com/provusinc/quoting/issues/991)) ([476a4bc](https://github.com/provusinc/quoting/commit/476a4bc7439ea4c498a6ba7140f290e47d724e2c))
- **psq-2918:** copy the label field to the task parameter value ([eb2b2bd](https://github.com/provusinc/quoting/commit/eb2b2bdde33a939b58d8dd7cd8f7c62c6fa262e5))
- **psq-2918:** copy the label field to the task parameter value ([88b75d1](https://github.com/provusinc/quoting/commit/88b75d1506e896202f68187e747a536cd64ba78b))
- **psq-3005:** formula field to conditionally show align to date for date alignment milestones ([#956](https://github.com/provusinc/quoting/issues/956)) ([7549725](https://github.com/provusinc/quoting/commit/7549725b9fc3042aa6fd99f13ea30d489a39bc65))
- **psq-3163:** Resource Role list is showing Ancillaries in estimate template ([#939](https://github.com/provusinc/quoting/issues/939)) ([dadb6a6](https://github.com/provusinc/quoting/commit/dadb6a6ccf127be1df90b4b652ca09db4da58caf))
- **psq-3330:** require occurrence of alignment field in milestone creation flow ([#955](https://github.com/provusinc/quoting/issues/955)) ([57ad152](https://github.com/provusinc/quoting/commit/57ad15277a223f0cfa10a4e453c8e8609d2b0374))
- **psq-3373:** changes for add/removing quote items during estimate sync ([#959](https://github.com/provusinc/quoting/issues/959)) ([69f0421](https://github.com/provusinc/quoting/commit/69f0421ea1c29b79d6b699a46c78f63620d6785f))
- **psq-3373:** sync estiamte to quote, delete sections for not applicable ([#973](https://github.com/provusinc/quoting/issues/973)) ([c31bd27](https://github.com/provusinc/quoting/commit/c31bd273f9dd329476bf1c545b41a65d8cc64a2c))
- **psq-3377:** grand total display issue ([#949](https://github.com/provusinc/quoting/issues/949)) ([e466eaf](https://github.com/provusinc/quoting/commit/e466eafae4160979b3803bc6b8094ec03cfb6482))
- **psq-3427:** updated filter in estimate service ([#971](https://github.com/provusinc/quoting/issues/971)) ([c5d38bc](https://github.com/provusinc/quoting/commit/c5d38bc19e0a970ce284cd6e58ea0bc8baac8348))
- **psq-3442:** change scope parameter dialog name header to parameter name ([#962](https://github.com/provusinc/quoting/issues/962)) ([d55cab9](https://github.com/provusinc/quoting/commit/d55cab9057fabda63195d13dca43a1ede846e892))
- **psq-3444:** parameter value dialog does not launch for newly created rows ([#964](https://github.com/provusinc/quoting/issues/964)) ([e88f499](https://github.com/provusinc/quoting/commit/e88f499fc1299f3830b9b5b8a088b8969dbc2587))
- **psq-3454:** add values button does not appear for the first row ([#963](https://github.com/provusinc/quoting/issues/963)) ([56f3ded](https://github.com/provusinc/quoting/commit/56f3ded33eab33c1d7b574ac33442d47b699fb4f))
- **psq-3458:** integer tier "to" value must be at least equal to the "from" value ([#965](https://github.com/provusinc/quoting/issues/965)) ([bfff058](https://github.com/provusinc/quoting/commit/bfff05888b1cdf0f484568f023ba6083df9c2744))
- **psq-3507:** show/hide Scope Discovery button on Estimate ([#977](https://github.com/provusinc/quoting/issues/977)) ([66ed6e5](https://github.com/provusinc/quoting/commit/66ed6e5e94c2aac32e4b8ae24c9ce1de6889aa90))
- **psq-3520:** save button not visible in dialog ([#978](https://github.com/provusinc/quoting/issues/978)) ([3c5a3b9](https://github.com/provusinc/quoting/commit/3c5a3b91868830948618880486b5f970dc3812ec))
- **psq-3528:** disabled trashcan button ([#983](https://github.com/provusinc/quoting/issues/983)) ([a188184](https://github.com/provusinc/quoting/commit/a1881847ac251b4df97ca376ec527f505e2ed406))
- **psq-3531:** added preemptive checks before running opportunity sync ([#987](https://github.com/provusinc/quoting/issues/987)) ([9cd29d4](https://github.com/provusinc/quoting/commit/9cd29d4c86726cdf7b4ff69b8f2a9951d37d2eb2))
- **psq-3538:** changed parameter name label ([#981](https://github.com/provusinc/quoting/issues/981)) ([9703ff5](https://github.com/provusinc/quoting/commit/9703ff5036a56bb7891847bc5741e024eaf2ba6a))
- remove extra labels ([32a0c48](https://github.com/provusinc/quoting/commit/32a0c48e9b1effd1f8c0ca922bd951ec7c7adb20))

### Reverts

- Revert "feat(cola adjustment): added api for adjusting cola rates and tests (#937)" (#942) ([a74f66c](https://github.com/provusinc/quoting/commit/a74f66cc20e4892990b865d97592c27b7a82963e)), closes [#937](https://github.com/provusinc/quoting/issues/937) [#942](https://github.com/provusinc/quoting/issues/942)

### [2.23.1](https://github.com/provusinc/quoting/compare/v2.23.0...v2.23.1) (2022-05-13)

### Bug Fixes

- **psq-3531:** add service id to the create quote from template flow ([2aa786e](https://github.com/provusinc/quoting/commit/2aa786e77a475280eb07f331d2f7a36f93a3a3c3))

## [2.23.0](https://github.com/provusinc/quoting/compare/v2.22.0...v2.23.0) (2022-05-03)

### Features

- **de-link:** add informational message to flexi page ([06c8b8b](https://github.com/provusinc/quoting/commit/06c8b8b6eb9a2639b5b7f59cc79d1a8dcf51cfc1))
- **estimate sync:** always show the estimate if its associated to a quote ([45fbe1c](https://github.com/provusinc/quoting/commit/45fbe1c6dfdec4b0c8ff404c5d57af2b1c057dca))

## [2.22.0](https://github.com/provusinc/quoting/compare/v2.21.0...v2.22.0) (2022-05-03)

### Features

- **psq-3356:** introduce an estimate tab to the quote ([#941](https://github.com/provusinc/quoting/issues/941)) ([#944](https://github.com/provusinc/quoting/issues/944)) ([c80bd6a](https://github.com/provusinc/quoting/commit/c80bd6a2cf9ac73de2f2bc59905335a21c80c6a2))
- **psq-366:** remove the logic around quote template ([#940](https://github.com/provusinc/quoting/issues/940)) ([#945](https://github.com/provusinc/quoting/issues/945)) ([a00c7f8](https://github.com/provusinc/quoting/commit/a00c7f86af0461aad0dfcaa7217efe34461b8136))

## [2.21.0](https://github.com/provusinc/quoting/compare/v2.20.0...v2.21.0) (2022-05-01)

### Features

- **trigger build:** ffwd build version to v2.20 and build v2.21 ([f5d442d](https://github.com/provusinc/quoting/commit/f5d442d1c21c14d64e2a5da3598623d04a0e9c1c))

## [2.18.0](https://github.com/provusinc/quoting/compare/v2.17.1...v2.18.0) (2022-05-01)

### Features

- add estimated revenue to an estimate ([ab9777c](https://github.com/provusinc/quoting/commit/ab9777c489196d389c0e02ae376bd76fa0ca3ed0))
- add retry mechanism to dialog service ([#932](https://github.com/provusinc/quoting/issues/932)) ([d3d5245](https://github.com/provusinc/quoting/commit/d3d52453a84089285d351cfaf59e5d6149ef43b4))
- **cola adjustments:** Create dialog for adjusting COLA rates in quote + QuickAction ([#931](https://github.com/provusinc/quoting/issues/931)) ([5e9b5f9](https://github.com/provusinc/quoting/commit/5e9b5f9c88b00fb1772b7fdf357f79574b92fe94))
- fix bugs with resource preferences dialogs ([6a33715](https://github.com/provusinc/quoting/commit/6a337155c3ae1ea0650f043037d21bfe5ab1dd6a))
- fix further deployment and test failures ([eb8829f](https://github.com/provusinc/quoting/commit/eb8829fdd1aabf32900eef90051efb24043fde0d))
- hide resource defaults if there are no attribute groups ([aff5f6c](https://github.com/provusinc/quoting/commit/aff5f6cf9678d8deb591ccdd6f63621295f24da1))
- move the i18n component to the proper directory ([407aa18](https://github.com/provusinc/quoting/commit/407aa18b03a530a8c321f19dbcd5aebda3e7bdec))
- **psq-2761:** changed alignment field to require ([#905](https://github.com/provusinc/quoting/issues/905)) ([ac349a4](https://github.com/provusinc/quoting/commit/ac349a4b3b2e0f15c5fca32c87ff2ea69ed1d60c))
- **psq-2849:** added title for phases in estimate ([#886](https://github.com/provusinc/quoting/issues/886)) ([d198fd3](https://github.com/provusinc/quoting/commit/d198fd38e5d9f97e766f66c62835eed404352fa2))
- **psq-2910:** delink quote from estimate ([#908](https://github.com/provusinc/quoting/issues/908)) ([288ba7d](https://github.com/provusinc/quoting/commit/288ba7d3ef6a1d3c53a22f715aa406e8c922dfb3))
- **psq-2971:** clone estimate while creating new scenario ([#925](https://github.com/provusinc/quoting/issues/925)) ([072f0a4](https://github.com/provusinc/quoting/commit/072f0a40fcb5a45f27b50946f381771118b60517))
- **psq-2974:** add link to estimate in quote header ([#926](https://github.com/provusinc/quoting/issues/926)) ([c1c70da](https://github.com/provusinc/quoting/commit/c1c70da1fa97f35b95a3ef7c1228766c31219241))
- **psq-2977:** validate positive year over year rate ([#901](https://github.com/provusinc/quoting/issues/901)) ([5145767](https://github.com/provusinc/quoting/commit/5145767d706df7eb263e3f7e0c75390a38983bd0))
- **quote configurator:** added a check for the estimateid to make time columns restricted ([#910](https://github.com/provusinc/quoting/issues/910)) ([b63bc24](https://github.com/provusinc/quoting/commit/b63bc247b9a7f2a712d4ef1fff55419a1169f436))
- **quote configurator:** Create "Add Period" button and dialog box for inputs ([#914](https://github.com/provusinc/quoting/issues/914)) ([a8ceeff](https://github.com/provusinc/quoting/commit/a8ceeff4efd9d62d7b5b497b8e807ecfcb2ecb8d))
- remove additional code ([853d62e](https://github.com/provusinc/quoting/commit/853d62eeb4492106158043216a81be8d9c397528))
- remove adjust rev/margin and reset functionality ([9fd8d1c](https://github.com/provusinc/quoting/commit/9fd8d1c983a899ae8ba4dc35a46dcf9a42546b71))
- remove adjust rev/margin and reset functionality ([fd0c533](https://github.com/provusinc/quoting/commit/fd0c533f61807533495d66517c75a6f937bd1a40))
- **resource role defaults:** resource role defaults overhaul ([#911](https://github.com/provusinc/quoting/issues/911)) ([ab1d4d6](https://github.com/provusinc/quoting/commit/ab1d4d695d417dcc09dece11010101bcf442c78f))
- **service recommendations:** pmd errors ([#930](https://github.com/provusinc/quoting/issues/930)) ([6ba4faa](https://github.com/provusinc/quoting/commit/6ba4faa75cf54f8eba4943ab966ae138fe8a6da7))
- **trigger build:** add back custom permissions ([ce565ba](https://github.com/provusinc/quoting/commit/ce565bacaf505e47b51d428a5d223047c70156be))
- **trigger build:** remove permissions ([5ecbb0e](https://github.com/provusinc/quoting/commit/5ecbb0e6aa07c8f56dfaab124095dfed0d95f8c2))

### Bug Fixes

- **psq-2847:** confirmation message displayed after clicking on delete button ([#860](https://github.com/provusinc/quoting/issues/860)) ([5ab1e3d](https://github.com/provusinc/quoting/commit/5ab1e3dbe2572db99615d6d759c4fec7f7575ee0))
- **psq-2901:** fixed sequence of added milestone ([#912](https://github.com/provusinc/quoting/issues/912)) ([eb3e311](https://github.com/provusinc/quoting/commit/eb3e3119c0148d20d63251f3436cf26bdf13c254))
- **psq-2940:** resolve error when removing a rate value ([#915](https://github.com/provusinc/quoting/issues/915)) ([ca56711](https://github.com/provusinc/quoting/commit/ca5671135411c04054bf7e6c726fcf1469ddd507))
- **psq-2965:** change cola year copy label ([#900](https://github.com/provusinc/quoting/issues/900)) ([2a185b0](https://github.com/provusinc/quoting/commit/2a185b0124c4c7f6c31aa1e1c2e135b9a0cc463c))
- **psq-3094:** cast string to number during split formatting ([#918](https://github.com/provusinc/quoting/issues/918)) ([227d472](https://github.com/provusinc/quoting/commit/227d472ce85dc47956dbefb0543ce141b2fc65ab))
- **psq1858:** fix for discount screen tab out issue ([#906](https://github.com/provusinc/quoting/issues/906)) ([e82f66e](https://github.com/provusinc/quoting/commit/e82f66ec60cc8aed7b742575f7a193bce7d70418))
- refresh the grid when the cost changes ([3d299ed](https://github.com/provusinc/quoting/commit/3d299ed09089e8cc995d868ae3080e6456a3314d))
- resolve cyclomatic complexity issues in quote triggers.cls ([52b22bd](https://github.com/provusinc/quoting/commit/52b22bde5cd71b89e7638349925ffa1c7dd97c3a))
- revert field name back ([b56ba72](https://github.com/provusinc/quoting/commit/b56ba72d0983bff9786dc36f21c44c72313bad02))
- **service recommendations:** consolidated flows to sync service recommendations ([#920](https://github.com/provusinc/quoting/issues/920)) ([ab54cfa](https://github.com/provusinc/quoting/commit/ab54cfad4522f3eb4f368a6fc1bac6f09542601d))
- **service recommendations:** test failures ([#924](https://github.com/provusinc/quoting/issues/924)) ([3a154c0](https://github.com/provusinc/quoting/commit/3a154c01ace854d47c97d9684b3cd6f2aaf52442))

## [2.18.0-next.2](https://github.com/provusinc/quoting/compare/v2.18.0-next.1...v2.18.0-next.2) (2022-05-01)

### Features

- **trigger build:** add back custom permissions ([ce565ba](https://github.com/provusinc/quoting/commit/ce565bacaf505e47b51d428a5d223047c70156be))

## [2.18.0-next.1](https://github.com/provusinc/quoting/compare/v2.17.1...v2.18.0-next.1) (2022-05-01)

### Features

- add estimated revenue to an estimate ([ab9777c](https://github.com/provusinc/quoting/commit/ab9777c489196d389c0e02ae376bd76fa0ca3ed0))
- add retry mechanism to dialog service ([#932](https://github.com/provusinc/quoting/issues/932)) ([d3d5245](https://github.com/provusinc/quoting/commit/d3d52453a84089285d351cfaf59e5d6149ef43b4))
- **cola adjustments:** Create dialog for adjusting COLA rates in quote + QuickAction ([#931](https://github.com/provusinc/quoting/issues/931)) ([5e9b5f9](https://github.com/provusinc/quoting/commit/5e9b5f9c88b00fb1772b7fdf357f79574b92fe94))
- fix bugs with resource preferences dialogs ([6a33715](https://github.com/provusinc/quoting/commit/6a337155c3ae1ea0650f043037d21bfe5ab1dd6a))
- fix further deployment and test failures ([eb8829f](https://github.com/provusinc/quoting/commit/eb8829fdd1aabf32900eef90051efb24043fde0d))
- move the i18n component to the proper directory ([407aa18](https://github.com/provusinc/quoting/commit/407aa18b03a530a8c321f19dbcd5aebda3e7bdec))
- **psq-2761:** changed alignment field to require ([#905](https://github.com/provusinc/quoting/issues/905)) ([ac349a4](https://github.com/provusinc/quoting/commit/ac349a4b3b2e0f15c5fca32c87ff2ea69ed1d60c))
- **psq-2849:** added title for phases in estimate ([#886](https://github.com/provusinc/quoting/issues/886)) ([d198fd3](https://github.com/provusinc/quoting/commit/d198fd38e5d9f97e766f66c62835eed404352fa2))
- **psq-2910:** delink quote from estimate ([#908](https://github.com/provusinc/quoting/issues/908)) ([288ba7d](https://github.com/provusinc/quoting/commit/288ba7d3ef6a1d3c53a22f715aa406e8c922dfb3))
- **psq-2971:** clone estimate while creating new scenario ([#925](https://github.com/provusinc/quoting/issues/925)) ([072f0a4](https://github.com/provusinc/quoting/commit/072f0a40fcb5a45f27b50946f381771118b60517))
- **psq-2974:** add link to estimate in quote header ([#926](https://github.com/provusinc/quoting/issues/926)) ([c1c70da](https://github.com/provusinc/quoting/commit/c1c70da1fa97f35b95a3ef7c1228766c31219241))
- **psq-2977:** validate positive year over year rate ([#901](https://github.com/provusinc/quoting/issues/901)) ([5145767](https://github.com/provusinc/quoting/commit/5145767d706df7eb263e3f7e0c75390a38983bd0))
- **quote configurator:** added a check for the estimateid to make time columns restricted ([#910](https://github.com/provusinc/quoting/issues/910)) ([b63bc24](https://github.com/provusinc/quoting/commit/b63bc247b9a7f2a712d4ef1fff55419a1169f436))
- **quote configurator:** Create "Add Period" button and dialog box for inputs ([#914](https://github.com/provusinc/quoting/issues/914)) ([a8ceeff](https://github.com/provusinc/quoting/commit/a8ceeff4efd9d62d7b5b497b8e807ecfcb2ecb8d))
- remove additional code ([853d62e](https://github.com/provusinc/quoting/commit/853d62eeb4492106158043216a81be8d9c397528))
- remove adjust rev/margin and reset functionality ([9fd8d1c](https://github.com/provusinc/quoting/commit/9fd8d1c983a899ae8ba4dc35a46dcf9a42546b71))
- remove adjust rev/margin and reset functionality ([fd0c533](https://github.com/provusinc/quoting/commit/fd0c533f61807533495d66517c75a6f937bd1a40))
- **resource role defaults:** resource role defaults overhaul ([#911](https://github.com/provusinc/quoting/issues/911)) ([ab1d4d6](https://github.com/provusinc/quoting/commit/ab1d4d695d417dcc09dece11010101bcf442c78f))
- **service recommendations:** pmd errors ([#930](https://github.com/provusinc/quoting/issues/930)) ([6ba4faa](https://github.com/provusinc/quoting/commit/6ba4faa75cf54f8eba4943ab966ae138fe8a6da7))
- **trigger build:** remove permissions ([5ecbb0e](https://github.com/provusinc/quoting/commit/5ecbb0e6aa07c8f56dfaab124095dfed0d95f8c2))

### Bug Fixes

- **psq-2847:** confirmation message displayed after clicking on delete button ([#860](https://github.com/provusinc/quoting/issues/860)) ([5ab1e3d](https://github.com/provusinc/quoting/commit/5ab1e3dbe2572db99615d6d759c4fec7f7575ee0))
- **psq-2901:** fixed sequence of added milestone ([#912](https://github.com/provusinc/quoting/issues/912)) ([eb3e311](https://github.com/provusinc/quoting/commit/eb3e3119c0148d20d63251f3436cf26bdf13c254))
- **psq-2940:** resolve error when removing a rate value ([#915](https://github.com/provusinc/quoting/issues/915)) ([ca56711](https://github.com/provusinc/quoting/commit/ca5671135411c04054bf7e6c726fcf1469ddd507))
- **psq-2965:** change cola year copy label ([#900](https://github.com/provusinc/quoting/issues/900)) ([2a185b0](https://github.com/provusinc/quoting/commit/2a185b0124c4c7f6c31aa1e1c2e135b9a0cc463c))
- **psq-3094:** cast string to number during split formatting ([#918](https://github.com/provusinc/quoting/issues/918)) ([227d472](https://github.com/provusinc/quoting/commit/227d472ce85dc47956dbefb0543ce141b2fc65ab))
- **psq1858:** fix for discount screen tab out issue ([#906](https://github.com/provusinc/quoting/issues/906)) ([e82f66e](https://github.com/provusinc/quoting/commit/e82f66ec60cc8aed7b742575f7a193bce7d70418))
- refresh the grid when the cost changes ([3d299ed](https://github.com/provusinc/quoting/commit/3d299ed09089e8cc995d868ae3080e6456a3314d))
- resolve cyclomatic complexity issues in quote triggers.cls ([52b22bd](https://github.com/provusinc/quoting/commit/52b22bde5cd71b89e7638349925ffa1c7dd97c3a))
- revert field name back ([b56ba72](https://github.com/provusinc/quoting/commit/b56ba72d0983bff9786dc36f21c44c72313bad02))
- **service recommendations:** consolidated flows to sync service recommendations ([#920](https://github.com/provusinc/quoting/issues/920)) ([ab54cfa](https://github.com/provusinc/quoting/commit/ab54cfad4522f3eb4f368a6fc1bac6f09542601d))
- **service recommendations:** test failures ([#924](https://github.com/provusinc/quoting/issues/924)) ([3a154c0](https://github.com/provusinc/quoting/commit/3a154c01ace854d47c97d9684b3cd6f2aaf52442))

### [2.17.1](https://github.com/provusinc/quoting/compare/v2.17.0...v2.17.1) (2022-04-27)

### Bug Fixes

- set the cloned estimates default field to false ([128c992](https://github.com/provusinc/quoting/commit/128c99254121020ec337a437043f893e78d55254))

## [2.17.0](https://github.com/provusinc/quoting/compare/v2.16.1...v2.17.0) (2022-04-27)

### Features

- opportunity linked quotes failed to sync ([8bcb2ce](https://github.com/provusinc/quoting/commit/8bcb2cee0d55f6565bf0dd82521a0b9d4b4e6673))

### [2.16.1](https://github.com/provusinc/quoting/compare/v2.16.0...v2.16.1) (2022-04-27)

### Bug Fixes

- **service recommendations:** consolidated flows to sync service recommendations ([#921](https://github.com/provusinc/quoting/issues/921)) ([cb0b526](https://github.com/provusinc/quoting/commit/cb0b526c57e711e607638166ccbfd09311ac30e4))

## [2.16.0](https://github.com/provusinc/quoting/compare/v2.15.1...v2.16.0) (2022-04-26)

### Features

- **quote contingency:** refresh the quote contingencies dialog ([97df2bd](https://github.com/provusinc/quoting/commit/97df2bdd98ba82eb5cc95f758fc75eee2e5b2de6))

### Bug Fixes

- add missing permission set ([85ce5a9](https://github.com/provusinc/quoting/commit/85ce5a94bf23e771003524037e51fa8b58bea1ef))

### [2.15.1](https://github.com/provusinc/quoting/compare/v2.15.0...v2.15.1) (2022-04-19)

### Bug Fixes

- ignore sync operation on record delete ([e996cf2](https://github.com/provusinc/quoting/commit/e996cf21efad4294340808996ee8a4f0810cea2b))

## [2.12.0](https://github.com/provusinc/quoting/compare/v2.11.0...v2.12.0) (2022-04-16)

### Features

- **trigger build:** rename estimated duration field ([7f1f2cc](https://github.com/provusinc/quoting/commit/7f1f2cc843426275f26b85d0d5238ee0b54d1ab5))

### Reverts

- Revert "feat(trigger build): rename estimated duration field" ([32b0587](https://github.com/provusinc/quoting/commit/32b0587186b19d4ae3af65e596ca1734b5f1d572))

## [2.11.0](https://github.com/provusinc/quoting/compare/v2.10.0...v2.11.0) (2022-04-16)

### Features

- **trigger build:** rename estimated duration field ([d41ebde](https://github.com/provusinc/quoting/commit/d41ebded8fdfb37545b2e8995da42b6c3a339a72))
- **trigger build:** rename estimated duration field ([a48d5cf](https://github.com/provusinc/quoting/commit/a48d5cf488345dce48920dabb92d555184f238ad))

## [2.10.0](https://github.com/provusinc/quoting/compare/v2.9.0...v2.10.0) (2022-04-16)

### Features

- **trigger build:** add all custom permissions back ([b278f60](https://github.com/provusinc/quoting/commit/b278f603fb03b5e90b9bc1709c86869e30e4b855))

## [2.9.0](https://github.com/provusinc/quoting/compare/v2.8.0...v2.9.0) (2022-04-16)

### Features

- add back in estimate fields ([775afa8](https://github.com/provusinc/quoting/commit/775afa859c5fcd1ffc444bca52adb157093093bf))
- add back in milestone fields ([6e89b69](https://github.com/provusinc/quoting/commit/6e89b696c50b519ff040aae82104231d6f954b3c))
- align all calendars to the user defined calendar ([#822](https://github.com/provusinc/quoting/issues/822)) ([2857607](https://github.com/provusinc/quoting/commit/2857607c750492713326f63b6a20c5547ba57f40))
- **cola adjustment:** Add COLA Adjustment setting + new menu items for COLA Adjustment ([#816](https://github.com/provusinc/quoting/issues/816)) ([0c5ce29](https://github.com/provusinc/quoting/commit/0c5ce29fea93e23371adb39757e44f762c25d476))
- **cola adjustment:** added feature flag and refactored code ([#839](https://github.com/provusinc/quoting/issues/839)) ([13f2519](https://github.com/provusinc/quoting/commit/13f2519595d155efcdbc19a56a9dab1bd1bf431f))
- **cola adjustment:** created two new percentage fields ([#812](https://github.com/provusinc/quoting/issues/812)) ([473b878](https://github.com/provusinc/quoting/commit/473b8788ca22a3f2f9e18181f18a1f606cf0eda3))
- **cola adjustment:** refactor for retrieving cola values ([#824](https://github.com/provusinc/quoting/issues/824)) ([fcf4c9b](https://github.com/provusinc/quoting/commit/fcf4c9b9e4a6cf88974df2fb773b66ce10f85711))
- convert create scenario simple checkbox to subscriber controlled ([06a1cbf](https://github.com/provusinc/quoting/commit/06a1cbfcde4261b32c1bf7940f8e8095bf3276fe))
- **create scenario:** Create a New Scenario Without Scenario Adjustments ([#867](https://github.com/provusinc/quoting/issues/867)) ([e5a5d51](https://github.com/provusinc/quoting/commit/e5a5d51a4ed641f8ec18341d1e1a957c212791c1))
- downgrade handsontable to 8.3.2 ([5092848](https://github.com/provusinc/quoting/commit/50928481c84f119540dfd3a0457912f2b6523f85))
- **milestone:** milestone creation flow ([#821](https://github.com/provusinc/quoting/issues/821)) ([65132f1](https://github.com/provusinc/quoting/commit/65132f16c2ca8321d83f34cad88151db2d6ca16b))
- **psq-1515:** estimate template to estimate conversion with phase changes ([#832](https://github.com/provusinc/quoting/issues/832)) ([93a171e](https://github.com/provusinc/quoting/commit/93a171e04ea115076d128f957a57eb7c9b33c0d5))
- **psq-1602:** create ratecard from quote feature ([#741](https://github.com/provusinc/quoting/issues/741)) ([464ee31](https://github.com/provusinc/quoting/commit/464ee31f5402d67df011963d77d273575ae77df2))
- **psq-1653:** hide resource roles with no estimated time from role preference list ([#815](https://github.com/provusinc/quoting/issues/815)) ([853f308](https://github.com/provusinc/quoting/commit/853f3084cbd76eb9ccdb19c757319a32e08c2cb7))
- **psq-1662:** show totals in estimate resource summary screen ([#855](https://github.com/provusinc/quoting/issues/855)) ([1222a01](https://github.com/provusinc/quoting/commit/1222a016cd59498f5304107ffc5917ad1537150a))
- **psq-1858:** fix for discount screen tab out issue ([d9856f2](https://github.com/provusinc/quoting/commit/d9856f2a6a96673eb24e732b1f7d2a3e034f4d65))
- **psq-2079:** apply cola rates in new dialog ([#861](https://github.com/provusinc/quoting/issues/861)) ([defbd0d](https://github.com/provusinc/quoting/commit/defbd0d5956aff7134d93c256ac43f6322f9a2fd))
- **psq-2299:** add resource default option in estimate screen ([#868](https://github.com/provusinc/quoting/issues/868)) ([2262b33](https://github.com/provusinc/quoting/commit/2262b33046d5e2dfcafb0787972fd9ea901f41b7))
- **psq-2300:** estimate cost implementation using formulas and rollups ([#898](https://github.com/provusinc/quoting/issues/898)) ([0e93e9c](https://github.com/provusinc/quoting/commit/0e93e9c17779a3bd717bd404d3e866b33f322e57))
- **psq-2300:** implement estimated total cost using resource defaults ([#893](https://github.com/provusinc/quoting/issues/893)) ([5ed684b](https://github.com/provusinc/quoting/commit/5ed684b23e4525cc0035ce068bdd58a02c7511d5))
- **psq-2421:** create rate card dialog changes ([#836](https://github.com/provusinc/quoting/issues/836)) ([#837](https://github.com/provusinc/quoting/issues/837)) ([eefe59a](https://github.com/provusinc/quoting/commit/eefe59aa6a560d7f3a93b3aba8ae93c5cdcfdf22))
- **psq-2764:** auto-save on rate cell change ([#874](https://github.com/provusinc/quoting/issues/874)) ([cf8d61f](https://github.com/provusinc/quoting/commit/cf8d61f14f8734743c4b92ec876a94804b72b581))
- **psq-2764:** cola tab permissions ([#872](https://github.com/provusinc/quoting/issues/872)) ([3f2f7d9](https://github.com/provusinc/quoting/commit/3f2f7d9f58613ddec9c9432c590c2cfe872e7b63))
- **psq-2764:** implement country/state picklists and percent-fixed for global rate admin ([#888](https://github.com/provusinc/quoting/issues/888)) ([38aa475](https://github.com/provusinc/quoting/commit/38aa475d2392e162fd14ce3e2f0f7dba33947b0e))
- **psq-2764:** location cola rate admin ([#866](https://github.com/provusinc/quoting/issues/866)) ([2cd1f1f](https://github.com/provusinc/quoting/commit/2cd1f1f2aa9dc20a74d3cb3a41da558039bc5a0c))
- **psq-2842:** introduce the ability to filter rate card items ([#853](https://github.com/provusinc/quoting/issues/853)) ([58828aa](https://github.com/provusinc/quoting/commit/58828aa2798319cb9662c1e2837dc06a5526a86f))
- **psq-2896:** allow decimal numbers for per unit durations ([#885](https://github.com/provusinc/quoting/issues/885)) ([8552dd2](https://github.com/provusinc/quoting/commit/8552dd207c4d09537d3ec0ea8aa758f959f51969))
- **psq-47:** add option to clone estimate template ([#806](https://github.com/provusinc/quoting/issues/806)) ([6147c9f](https://github.com/provusinc/quoting/commit/6147c9f42a6e02d7b831243752ce0acc8768b648))
- **psq-47:** added class to permission set ([#830](https://github.com/provusinc/quoting/issues/830)) ([3c2e455](https://github.com/provusinc/quoting/commit/3c2e455cfbbc32b74ad0799b7d9e9814c38f2d7e))
- **psq-792:** disallow invalid numbers ([#813](https://github.com/provusinc/quoting/issues/813)) ([0b30802](https://github.com/provusinc/quoting/commit/0b308028e7dc8df429ea7021818ab9899a724a82))
- remove the estimated duration field ([f9690c0](https://github.com/provusinc/quoting/commit/f9690c048254f22365f478c28c9911608665e47e))
- trigger build ([17d0c94](https://github.com/provusinc/quoting/commit/17d0c94a0261e866418d5ca50e44a976b136dfb7))
- **trigger build:** add back v1 of total estimated cost field ([c172158](https://github.com/provusinc/quoting/commit/c172158244d23ce16c72bf24338afbc5cb55708f))
- **trigger build:** build provus static resource using legacy peer deps ([be53dc0](https://github.com/provusinc/quoting/commit/be53dc0e4627c0ccd84e19ff2c2ca9c7052a9e1c))
- **trigger build:** changing total estimated cost to a formula field ([8509444](https://github.com/provusinc/quoting/commit/850944489b9f7b86b783ab0342647797adad0cae))
- **trigger build:** cleanup estimate layout and simple scenarios ([0eeec67](https://github.com/provusinc/quoting/commit/0eeec673477b3c8becc51fe2256dff857ca3c2fa))
- **trigger build:** downgrade to hot 8.3.2 ([d2b1ecc](https://github.com/provusinc/quoting/commit/d2b1ecc9b9e9915218a06c16cd6bf506ff090ca4))
- **trigger build:** enable the create simple scenarios feature ([a2b38c7](https://github.com/provusinc/quoting/commit/a2b38c7c1cf625071cfb441fc8896ab3ed23ee8f))
- **trigger build:** fix create scenario simple settings ([2f12496](https://github.com/provusinc/quoting/commit/2f124964bf39afd756616fbee7b9b6a25454857f))
- **trigger build:** fix create scenario simple settings ([ed269fc](https://github.com/provusinc/quoting/commit/ed269fcf1d9ae362dec2d9dcf2275f3e93682524))
- **trigger build:** fix custom metadata on provus configurator setting ([f55b40d](https://github.com/provusinc/quoting/commit/f55b40d1e3d5a96babd0f1beb04bbf16d8f0419b))
- **trigger build:** fix custom metadata on provus configurator setting ([5f38b4e](https://github.com/provusinc/quoting/commit/5f38b4ea37d2ff59081f57f6fae886dfa69c1afe))
- **trigger build:** make setting subscriber controlled ([a2e11bf](https://github.com/provusinc/quoting/commit/a2e11bf1dd8c38bc1fe50ef1d0114f6fc66bbeed))
- **trigger build:** rebuild package with deleted field ([b5d25a4](https://github.com/provusinc/quoting/commit/b5d25a41dc56cd1b4eddfd6f198d59793833c652))
- **trigger build:** remove all custom permissions ([19bfd64](https://github.com/provusinc/quoting/commit/19bfd641318d9beef43af597c3506035700197ff))
- **trigger build:** testing fix for custom metadata ([876d9a0](https://github.com/provusinc/quoting/commit/876d9a090adfeba2f26c974d6ed85139452366d4))
- **trigger build:** trigger the release ([3305d59](https://github.com/provusinc/quoting/commit/3305d5981b74c210036dc0433b0683a5428f3c04))
- **trigger release:** ignore semantic version check for v2.11 ([853c251](https://github.com/provusinc/quoting/commit/853c25148431629882ecc5406b6fd84db92f80a3))

### Bug Fixes

- **2903:** Estimate scope summary dialog displays the incorrect record ([#864](https://github.com/provusinc/quoting/issues/864)) ([f612239](https://github.com/provusinc/quoting/commit/f612239e34c01b74e6910ae3959e48936ddfb6cc))
- add occurrence dat to the permission set ([69c832e](https://github.com/provusinc/quoting/commit/69c832ef2afe42d48de11d95f04541b19fdf86a9))
- additional day increments are being calculated for even weeks ([#825](https://github.com/provusinc/quoting/issues/825)) ([7526487](https://github.com/provusinc/quoting/commit/7526487f573f2b908d88a12d7efe66d90fc64b50))
- **cola adjustment:** handles empty or zeroed values ([#894](https://github.com/provusinc/quoting/issues/894)) ([88659b0](https://github.com/provusinc/quoting/commit/88659b019085a5fe6aa6b219c7d2e34a40fcb875))
- double check the validity of the split-input field before saving ([#833](https://github.com/provusinc/quoting/issues/833)) ([7975a8c](https://github.com/provusinc/quoting/commit/7975a8ca8c7dbf01d75ffde307109d3779198d1c))
- fix the sentence case for cola objects ([9844926](https://github.com/provusinc/quoting/commit/9844926478c8713fb9de4974df77773c7d37f6f0))
- hide the milestones tab when the milestones permission is not enabled ([67a3559](https://github.com/provusinc/quoting/commit/67a355955b57178649d21bacf171e4e24eb82b6d))
- package.json & package-lock.json to reduce vulnerabilities ([#809](https://github.com/provusinc/quoting/issues/809)) ([45f9351](https://github.com/provusinc/quoting/commit/45f9351eebc82622caada4809c508f2a471d7ab9))
- **project milestone:** amended base code to account for namespace ([#891](https://github.com/provusinc/quoting/issues/891)) ([84287dd](https://github.com/provusinc/quoting/commit/84287ddc220d0cec94075b52a2855bea19f30d40))
- **project milestone:** delete project milestone from table ([#841](https://github.com/provusinc/quoting/issues/841)) ([f3ad776](https://github.com/provusinc/quoting/commit/f3ad7760f66a894c76806f8497d5a6a32d8dea9b))
- **psq-1858:** fix for discount screen tab out issue ([#875](https://github.com/provusinc/quoting/issues/875)) ([46ec08e](https://github.com/provusinc/quoting/commit/46ec08ea4b7c4278ad81a82e5d640985cc89a999))
- **psq-2274:** parameter values are not saved ([#828](https://github.com/provusinc/quoting/issues/828)) ([48839cd](https://github.com/provusinc/quoting/commit/48839cd60213f15c681ae2576fa903b03180770b))
- **psq-2353:** check the validity of the split input field before allowing a save ([292529a](https://github.com/provusinc/quoting/commit/292529a9dfc6e32e142f9f7b9a45330dc80935ca))
- **psq-2356:** Integer Tier--> Showing "Add user" instead of "Add rows" while adding rows in Define Recommended Durations ([#814](https://github.com/provusinc/quoting/issues/814)) ([fa197e1](https://github.com/provusinc/quoting/commit/fa197e1b42482c4f87e24d51dd7557db9db30564))
- **psq-2362:** fix for margin becoming blank for nonbillable addon ([#820](https://github.com/provusinc/quoting/issues/820)) ([4077679](https://github.com/provusinc/quoting/commit/4077679927bdea04a5012565d8d83311ff828c2d))
- **psq-2363:** fix for incorrect nonbillable context menu in addon ([#819](https://github.com/provusinc/quoting/issues/819)) ([575eec3](https://github.com/provusinc/quoting/commit/575eec30802c5ff6d2c9643f667f395ad1ee97db))
- **psq-2364:** non billable amount, margin are not updated in quote header ([#840](https://github.com/provusinc/quoting/issues/840)) ([8d84eca](https://github.com/provusinc/quoting/commit/8d84ecabaf2b95680d0d25ae8a844d3fc669dffe))
- **psq-2366:** spelling for daily is incorrect for time period group ([#823](https://github.com/provusinc/quoting/issues/823)) ([b5cdb9d](https://github.com/provusinc/quoting/commit/b5cdb9dbdc74236b9fd99156704bdecfe24a4ae1))
- **psq-2404:** fix for estimate template clone issue ([#827](https://github.com/provusinc/quoting/issues/827)) ([b276b17](https://github.com/provusinc/quoting/commit/b276b174a570a5abb0e86030190d35b30dac3707))
- **psq-2421:** create rate card dialog changes ([#836](https://github.com/provusinc/quoting/issues/836)) ([0cfbead](https://github.com/provusinc/quoting/commit/0cfbead4c30afb35798abee06ba9dd22a8fa598f))
- **psq-2424:** unable to create estimate template ([#831](https://github.com/provusinc/quoting/issues/831)) ([4ea0b11](https://github.com/provusinc/quoting/commit/4ea0b11bcb47f90ab310efd0877ac56abd14a2e4))
- **psq-2506:** update flow header labels ([#856](https://github.com/provusinc/quoting/issues/856)) ([bb49621](https://github.com/provusinc/quoting/commit/bb496211311cf16bf4849f7cb372ccfca7ab79c6))
- **psq-2506:** update flow header labels ([#859](https://github.com/provusinc/quoting/issues/859)) ([c7b461e](https://github.com/provusinc/quoting/commit/c7b461e8e638941b354b6e5ee7de0ec2d87bbf6b))
- **psq-2508:** require milestone alignment selection ([#847](https://github.com/provusinc/quoting/issues/847)) ([70440a6](https://github.com/provusinc/quoting/commit/70440a6342c3e752a69e00c02ab4d5dbbcd0bcbf))
- **psq-2509:** milestone dialog title incorrect ([#851](https://github.com/provusinc/quoting/issues/851)) ([d54d508](https://github.com/provusinc/quoting/commit/d54d508b6a6fdf6cbf0855250787137e3ffa2e5f))
- **psq-2510, psq-2767:** blank milestone values and UI updates ([#845](https://github.com/provusinc/quoting/issues/845)) ([e084263](https://github.com/provusinc/quoting/commit/e084263cf7c5e428270d445690b1482cd449b994))
- **psq-2692:** fix for activity group sequence sort issue ([#843](https://github.com/provusinc/quoting/issues/843)) ([be25352](https://github.com/provusinc/quoting/commit/be253522be8dbb48992cfdc263b9da493d2938eb))
- **psq-2762:** require offset unit value ([#850](https://github.com/provusinc/quoting/issues/850)) ([741cbd4](https://github.com/provusinc/quoting/commit/741cbd49554f4c58e147abf5ae2b4afc65c74a96))
- **psq-2850,psq-2848:** phase icon ,collapse action issue in estimate tree grid ([#858](https://github.com/provusinc/quoting/issues/858)) ([4038599](https://github.com/provusinc/quoting/commit/40385991d0005bd8adfd53115265dba1d0253b1a))
- **psq-2851:** clone estimate with phases ([#870](https://github.com/provusinc/quoting/issues/870)) ([a542767](https://github.com/provusinc/quoting/commit/a542767b13123fa9dca3530ead52362f3f9bbd5e))
- **psq-2919:** fix for passthrough spelling issue ([#878](https://github.com/provusinc/quoting/issues/878)) ([d5bd42d](https://github.com/provusinc/quoting/commit/d5bd42dd0eb8dc2916fb6ff9fbce17d68840edd6))
- **resource split:** split percentage rounding issue ([#857](https://github.com/provusinc/quoting/issues/857)) ([1b6b67d](https://github.com/provusinc/quoting/commit/1b6b67d3919904a28fe8a9c4fab78658aba9b219))
- upgrade @salesforce-ux/design-system from 2.17.2 to 2.17.5 ([#817](https://github.com/provusinc/quoting/issues/817)) ([a78b084](https://github.com/provusinc/quoting/commit/a78b084c484a22aac385bf61eb77631f2c3b52f0))

### Reverts

- Revert "refactor: rename COLA to Cola in api names (#862)" (#865) ([b9ab695](https://github.com/provusinc/quoting/commit/b9ab695504f7462202d34866eb836211c516a968)), closes [#862](https://github.com/provusinc/quoting/issues/862) [#865](https://github.com/provusinc/quoting/issues/865)

## [2.8.0](https://github.com/provusinc/quoting/compare/v2.7.1...v2.8.0) (2022-03-23)

### Features

- trigger build ([ab008ef](https://github.com/provusinc/quoting/commit/ab008efef8c8eb497ebb0210b39fa5b9341c73c8))

### Bug Fixes

- hide the milestones tab when the milestones permission is not enabled ([73c4fee](https://github.com/provusinc/quoting/commit/73c4feee4c0230b1078072e8b55db696c19ecbdf))
- the section hierarchy is not copied from a quote template -> quote ([#846](https://github.com/provusinc/quoting/issues/846)) ([55ff195](https://github.com/provusinc/quoting/commit/55ff195a223ac69c4eb924ae7c6325fb7e903225))

### [2.5.1](https://github.com/provusinc/quoting/compare/v2.5.0...v2.5.1) (2022-03-13)

### Bug Fixes

- use field metadata import to display the create quote from template form ([#818](https://github.com/provusinc/quoting/issues/818)) ([3855868](https://github.com/provusinc/quoting/commit/3855868148b1d5651fa35dc9d279681ffd4e7a06))

## [2.5.0](https://github.com/provusinc/quoting/compare/v2.4.0...v2.5.0) (2022-03-11)

### Features

- introduce a sequence number fields for split resources ([c4cacf1](https://github.com/provusinc/quoting/commit/c4cacf19dad1fed4dec6a7c3c2209b559847d47c))
- **project milestone:** add project milestone tab and basic display table ([#798](https://github.com/provusinc/quoting/issues/798)) ([265a2cd](https://github.com/provusinc/quoting/commit/265a2cd7dc53fd0ac8aa0619d70d20a39524c455))
- **psq-1502:** ability to define non-billable addons with a context menu option ([#781](https://github.com/provusinc/quoting/issues/781)) ([723be4b](https://github.com/provusinc/quoting/commit/723be4bba72ff11380fd6f4b8e5bcb6903826124))
- **psq-1712:** factors in resource split values when converting estimate to quote ([#776](https://github.com/provusinc/quoting/issues/776)) ([1b86945](https://github.com/provusinc/quoting/commit/1b869452c5f8f03f98085278b7ccadb917dae864))
- **psq-1712:** factors in resource split values when converting estimate to quote ([#791](https://github.com/provusinc/quoting/issues/791)) ([0c36884](https://github.com/provusinc/quoting/commit/0c368843fbf98bd35c8e614da9ed5754a5b9438f))
- **psq-2298:** enable the disable opportunity sync setting for edit ([4e123f7](https://github.com/provusinc/quoting/commit/4e123f7e92e31ec9bda6c2f466bdced34af53db8))
- **psq-2298:** un-protect the provus default configurator setting ([08368e7](https://github.com/provusinc/quoting/commit/08368e7bc37b0f4998a24fd8a682b302cefae241))
- remove deprecated product2 external id field from the schema ([baf9147](https://github.com/provusinc/quoting/commit/baf9147e12e8187ddce78a28efc0cf297a694f74))

### Bug Fixes

- cast resource split sequence field to an integer ([83e9b37](https://github.com/provusinc/quoting/commit/83e9b37eed006663a5467d42df5ac8a665642484))
- **estimate template:** make value input fields required ([#803](https://github.com/provusinc/quoting/issues/803)) ([fe6d6ba](https://github.com/provusinc/quoting/commit/fe6d6ba4638da7255746c02a73f41ffccbc83472))
- **psq-1502:** ability to define non-billable addons with a context menu option ([#781](https://github.com/provusinc/quoting/issues/781)) ([d930d1d](https://github.com/provusinc/quoting/commit/d930d1dc00f2923b1372c63c38965213874fc159))
- **psq-2168:** update quote totals after changing rate conversion factor ([#795](https://github.com/provusinc/quoting/issues/795)) ([87d9e18](https://github.com/provusinc/quoting/commit/87d9e18c448ae87ef173dd02514d50e132f36b39))
- **psq-2174:** disallow split percentage of 0 ([#793](https://github.com/provusinc/quoting/issues/793)) ([c53904a](https://github.com/provusinc/quoting/commit/c53904ab54cdd7108ed79ba29c02f7d16685fe56))
- **psq-2194:** added project phase label for toggle ([#792](https://github.com/provusinc/quoting/issues/792)) ([20d6b15](https://github.com/provusinc/quoting/commit/20d6b155a1d5c2d06aa7b0e4843245ced141d873))
- **psq-2262:** calculate period span correctly expecting whole number percentage values ([#802](https://github.com/provusinc/quoting/issues/802)) ([8fd4dce](https://github.com/provusinc/quoting/commit/8fd4dce8516f2a0259a7d070ab0eae9b8731575e))
- **psq-2353:** set the minimum allowable split percentage to two ([#808](https://github.com/provusinc/quoting/issues/808)) ([bc1d5a4](https://github.com/provusinc/quoting/commit/bc1d5a4e820dbc09fe797d39d302c2f6e39442d5))

### Reverts

- Revert "feat(psq-1712): factors in resource split values when converting estimate to quote (#776)" (#790) ([d9cbf73](https://github.com/provusinc/quoting/commit/d9cbf7372dc7af58eb41d73458258df49c6666b4)), closes [#776](https://github.com/provusinc/quoting/issues/776) [#790](https://github.com/provusinc/quoting/issues/790)

## [2.5.0-next.9](https://github.com/provusinc/quoting/compare/v2.5.0-next.8...v2.5.0-next.9) (2022-03-10)

### Features

- remove deprecated product2 external id field from the schema ([baf9147](https://github.com/provusinc/quoting/commit/baf9147e12e8187ddce78a28efc0cf297a694f74))

### Bug Fixes

- **psq-2353:** set the minimum allowable split percentage to two ([#808](https://github.com/provusinc/quoting/issues/808)) ([bc1d5a4](https://github.com/provusinc/quoting/commit/bc1d5a4e820dbc09fe797d39d302c2f6e39442d5))

## [2.5.0-next.8](https://github.com/provusinc/quoting/compare/v2.5.0-next.7...v2.5.0-next.8) (2022-03-10)

### Features

- **psq-2298:** un-protect the provus default configurator setting ([08368e7](https://github.com/provusinc/quoting/commit/08368e7bc37b0f4998a24fd8a682b302cefae241))

## [2.5.0-next.7](https://github.com/provusinc/quoting/compare/v2.5.0-next.6...v2.5.0-next.7) (2022-03-10)

### Bug Fixes

- **psq-2262:** calculate period span correctly expecting whole number percentage values ([#802](https://github.com/provusinc/quoting/issues/802)) ([8fd4dce](https://github.com/provusinc/quoting/commit/8fd4dce8516f2a0259a7d070ab0eae9b8731575e))

## [2.5.0-next.6](https://github.com/provusinc/quoting/compare/v2.5.0-next.5...v2.5.0-next.6) (2022-03-10)

### Bug Fixes

- **estimate template:** make value input fields required ([#803](https://github.com/provusinc/quoting/issues/803)) ([fe6d6ba](https://github.com/provusinc/quoting/commit/fe6d6ba4638da7255746c02a73f41ffccbc83472))

## [2.5.0-next.5](https://github.com/provusinc/quoting/compare/v2.5.0-next.4...v2.5.0-next.5) (2022-03-10)

### Features

- introduce a sequence number fields for split resources ([c4cacf1](https://github.com/provusinc/quoting/commit/c4cacf19dad1fed4dec6a7c3c2209b559847d47c))
- **psq-2298:** enable the disable opportunity sync setting for edit ([4e123f7](https://github.com/provusinc/quoting/commit/4e123f7e92e31ec9bda6c2f466bdced34af53db8))

### Bug Fixes

- cast resource split sequence field to an integer ([83e9b37](https://github.com/provusinc/quoting/commit/83e9b37eed006663a5467d42df5ac8a665642484))

## [2.5.0-next.4](https://github.com/provusinc/quoting/compare/v2.5.0-next.3...v2.5.0-next.4) (2022-03-09)

### Features

- **project milestone:** add project milestone tab and basic display table ([#798](https://github.com/provusinc/quoting/issues/798)) ([265a2cd](https://github.com/provusinc/quoting/commit/265a2cd7dc53fd0ac8aa0619d70d20a39524c455))

## [2.5.0-next.3](https://github.com/provusinc/quoting/compare/v2.5.0-next.2...v2.5.0-next.3) (2022-03-08)

### Features

- **psq-1502:** ability to define non-billable addons with a context menu option ([#781](https://github.com/provusinc/quoting/issues/781)) ([723be4b](https://github.com/provusinc/quoting/commit/723be4bba72ff11380fd6f4b8e5bcb6903826124))

### Bug Fixes

- **psq-1502:** ability to define non-billable addons with a context menu option ([#781](https://github.com/provusinc/quoting/issues/781)) ([d930d1d](https://github.com/provusinc/quoting/commit/d930d1dc00f2923b1372c63c38965213874fc159))
- **psq-2168:** update quote totals after changing rate conversion factor ([#795](https://github.com/provusinc/quoting/issues/795)) ([87d9e18](https://github.com/provusinc/quoting/commit/87d9e18c448ae87ef173dd02514d50e132f36b39))
- **psq-2174:** disallow split percentage of 0 ([#793](https://github.com/provusinc/quoting/issues/793)) ([c53904a](https://github.com/provusinc/quoting/commit/c53904ab54cdd7108ed79ba29c02f7d16685fe56))
- **psq-2194:** added project phase label for toggle ([#792](https://github.com/provusinc/quoting/issues/792)) ([20d6b15](https://github.com/provusinc/quoting/commit/20d6b155a1d5c2d06aa7b0e4843245ced141d873))

## [2.5.0-next.2](https://github.com/provusinc/quoting/compare/v2.5.0-next.1...v2.5.0-next.2) (2022-03-07)

### Features

- **psq-1712:** factors in resource split values when converting estimate to quote ([#791](https://github.com/provusinc/quoting/issues/791)) ([0c36884](https://github.com/provusinc/quoting/commit/0c368843fbf98bd35c8e614da9ed5754a5b9438f))

## [2.5.0-next.1](https://github.com/provusinc/quoting/compare/v2.4.0...v2.5.0-next.1) (2022-03-05)

### Features

- **psq-1712:** factors in resource split values when converting estimate to quote ([#776](https://github.com/provusinc/quoting/issues/776)) ([1b86945](https://github.com/provusinc/quoting/commit/1b869452c5f8f03f98085278b7ccadb917dae864))

### Reverts

- Revert "feat(psq-1712): factors in resource split values when converting estimate to quote (#776)" (#790) ([d9cbf73](https://github.com/provusinc/quoting/commit/d9cbf7372dc7af58eb41d73458258df49c6666b4)), closes [#776](https://github.com/provusinc/quoting/issues/776) [#790](https://github.com/provusinc/quoting/issues/790)

## [2.4.0](https://github.com/provusinc/quoting/compare/v2.3.0...v2.4.0) (2022-03-05)

### Features

- add feature flag to control project phases ([adcace5](https://github.com/provusinc/quoting/commit/adcace555c178718314a64b938f2d8d52a7e9af7))
- **psq-1878:** introduce create new milestone flow ([#788](https://github.com/provusinc/quoting/issues/788)) ([fcb29fd](https://github.com/provusinc/quoting/commit/fcb29fdce331cf525b66ed82eb1af06d73a145a1))

### Bug Fixes

- resolve query issues around developer name ([9aa0319](https://github.com/provusinc/quoting/commit/9aa031994d9196b7e4c3cfcb42c10e45b75548da))
- unprotect custom permissions so they can be utilized in a flexi page ([a4a0ca9](https://github.com/provusinc/quoting/commit/a4a0ca972bf49311562c55c6ea9909080fe3e9ca))
- userPermission -> customPermissions ([9bfbade](https://github.com/provusinc/quoting/commit/9bfbade83078ff7582e0c5b47fc19c8201ab8ab6))

## [2.4.0-next.5](https://github.com/provusinc/quoting/compare/v2.4.0-next.4...v2.4.0-next.5) (2022-03-05)

### Features

- add feature flag to control project phases ([adcace5](https://github.com/provusinc/quoting/commit/adcace555c178718314a64b938f2d8d52a7e9af7))

## [2.4.0-next.4](https://github.com/provusinc/quoting/compare/v2.4.0-next.3...v2.4.0-next.4) (2022-03-05)

### Bug Fixes

- userPermission -> customPermissions ([9bfbade](https://github.com/provusinc/quoting/commit/9bfbade83078ff7582e0c5b47fc19c8201ab8ab6))

## [2.4.0-next.3](https://github.com/provusinc/quoting/compare/v2.4.0-next.2...v2.4.0-next.3) (2022-03-05)

### Bug Fixes

- resolve query issues around developer name ([9aa0319](https://github.com/provusinc/quoting/commit/9aa031994d9196b7e4c3cfcb42c10e45b75548da))

## [2.4.0-next.2](https://github.com/provusinc/quoting/compare/v2.4.0-next.1...v2.4.0-next.2) (2022-03-04)

### Bug Fixes

- unprotect custom permissions so they can be utilized in a flexi page ([a4a0ca9](https://github.com/provusinc/quoting/commit/a4a0ca972bf49311562c55c6ea9909080fe3e9ca))

## [2.4.0-next.1](https://github.com/provusinc/quoting/compare/v2.3.0...v2.4.0-next.1) (2022-03-04)

### Features

- **psq-1878:** introduce create new milestone flow ([#788](https://github.com/provusinc/quoting/issues/788)) ([fcb29fd](https://github.com/provusinc/quoting/commit/fcb29fdce331cf525b66ed82eb1af06d73a145a1))

## [2.3.0](https://github.com/provusinc/quoting/compare/v2.2.0...v2.3.0) (2022-03-04)

### Features

- expose some of the product mappings for modification by the subscriber ([673efd4](https://github.com/provusinc/quoting/commit/673efd4d7a325196d0caf3d65496bbbab1a243d6))
- move the scenario code logic behind a feature flag ([a6181b8](https://github.com/provusinc/quoting/commit/a6181b88f659108af65ccb339615220cdbceb129))

### Bug Fixes

- **psq-2194:** estimate template without phases should not show project phase title ([#786](https://github.com/provusinc/quoting/issues/786)) ([3d0eb72](https://github.com/provusinc/quoting/commit/3d0eb72eede131d9c6de8df2ce6e8f14208f7381))

## [2.3.0-next.2](https://github.com/provusinc/quoting/compare/v2.3.0-next.1...v2.3.0-next.2) (2022-03-04)

### Features

- move the scenario code logic behind a feature flag ([a6181b8](https://github.com/provusinc/quoting/commit/a6181b88f659108af65ccb339615220cdbceb129))

### Bug Fixes

- **psq-2194:** estimate template without phases should not show project phase title ([#786](https://github.com/provusinc/quoting/issues/786)) ([3d0eb72](https://github.com/provusinc/quoting/commit/3d0eb72eede131d9c6de8df2ce6e8f14208f7381))

## [2.3.0-next.1](https://github.com/provusinc/quoting/compare/v2.2.0...v2.3.0-next.1) (2022-03-04)

### Features

- expose some of the product mappings for modification by the subscriber ([673efd4](https://github.com/provusinc/quoting/commit/673efd4d7a325196d0caf3d65496bbbab1a243d6))

## [2.2.0](https://github.com/provusinc/quoting/compare/v2.1.0...v2.2.0) (2022-03-03)

### Features

- add feature flag management ([dcb59b7](https://github.com/provusinc/quoting/commit/dcb59b790e74b1617d735e99418d109cb8215109))
- make the provus configurations object public ([88d668d](https://github.com/provusinc/quoting/commit/88d668db1e420dd066f6901b0de3e58d492964d7))
- remove oob configuration setting ([07dff99](https://github.com/provusinc/quoting/commit/07dff9978a12cf0a48abbe2f96ce5ca8093fb968))

### Bug Fixes

- do not attempt delete setup entities if there is nothing to delete ([f632649](https://github.com/provusinc/quoting/commit/f632649f215296dc40a5eb6299e5149a1d1b7f93))
- mark the custom permissions as required ([c8b0a7b](https://github.com/provusinc/quoting/commit/c8b0a7ba32d280985839246e6996e6a750115d7b))
- **psq-2089:** estimate to quote conversion ([#778](https://github.com/provusinc/quoting/issues/778)) ([9c4653b](https://github.com/provusinc/quoting/commit/9c4653bf193c5662f2f656dfd51509bbec7a134c))
- **psq-2165:** make quote name and rename fields mandatory ([#780](https://github.com/provusinc/quoting/issues/780)) ([a3da708](https://github.com/provusinc/quoting/commit/a3da70827cd8eea9722dd10b496e31d1e4585250))
- **psq-2168, psq-2174:** set split percentage scale to 2, disallow zero value ([#777](https://github.com/provusinc/quoting/issues/777)) ([9dc69ba](https://github.com/provusinc/quoting/commit/9dc69ba6f6ebcbe15934410d096903bd369d0a0f))
- **psq-2169:** updated quote rate card filter ([#779](https://github.com/provusinc/quoting/issues/779)) ([083b6ba](https://github.com/provusinc/quoting/commit/083b6ba6e55fe5c7046b7d5e8ac6af645a8e525c))
- **psq-2175:** split resources dialog doesn't close ([#775](https://github.com/provusinc/quoting/issues/775)) ([8742b7d](https://github.com/provusinc/quoting/commit/8742b7d6c2a5e06865b897d708b96c100e6f8a4d))
- re-add missing custom metadata ([88eb0ad](https://github.com/provusinc/quoting/commit/88eb0adc859e18721de5425d9e342d3b440e33fb))

## [2.2.0-next.3](https://github.com/provusinc/quoting/compare/v2.2.0-next.2...v2.2.0-next.3) (2022-03-03)

### Bug Fixes

- do not attempt delete setup entities if there is nothing to delete ([f632649](https://github.com/provusinc/quoting/commit/f632649f215296dc40a5eb6299e5149a1d1b7f93))

## [2.2.0-next.2](https://github.com/provusinc/quoting/compare/v2.2.0-next.1...v2.2.0-next.2) (2022-03-03)

### Bug Fixes

- **psq-2165:** make quote name and rename fields mandatory ([#780](https://github.com/provusinc/quoting/issues/780)) ([a3da708](https://github.com/provusinc/quoting/commit/a3da70827cd8eea9722dd10b496e31d1e4585250))

## [2.2.0-next.1](https://github.com/provusinc/quoting/compare/v2.1.0...v2.2.0-next.1) (2022-03-03)

### Features

- add feature flag management ([dcb59b7](https://github.com/provusinc/quoting/commit/dcb59b790e74b1617d735e99418d109cb8215109))

### Bug Fixes

- mark the custom permissions as required ([c8b0a7b](https://github.com/provusinc/quoting/commit/c8b0a7ba32d280985839246e6996e6a750115d7b))
- **psq-2089:** estimate to quote conversion ([#778](https://github.com/provusinc/quoting/issues/778)) ([9c4653b](https://github.com/provusinc/quoting/commit/9c4653bf193c5662f2f656dfd51509bbec7a134c))
- **psq-2168, psq-2174:** set split percentage scale to 2, disallow zero value ([#777](https://github.com/provusinc/quoting/issues/777)) ([9dc69ba](https://github.com/provusinc/quoting/commit/9dc69ba6f6ebcbe15934410d096903bd369d0a0f))
- **psq-2169:** updated quote rate card filter ([#779](https://github.com/provusinc/quoting/issues/779)) ([083b6ba](https://github.com/provusinc/quoting/commit/083b6ba6e55fe5c7046b7d5e8ac6af645a8e525c))
- **psq-2175:** split resources dialog doesn't close ([#775](https://github.com/provusinc/quoting/issues/775)) ([8742b7d](https://github.com/provusinc/quoting/commit/8742b7d6c2a5e06865b897d708b96c100e6f8a4d))

## [1.20.0-next.18](https://github.com/provusinc/quoting/compare/v1.20.0-next.17...v1.20.0-next.18) (2022-03-02)

### Bug Fixes

- set the cacheable flag to true for experimental features ([#773](https://github.com/provusinc/quoting/issues/773)) ([164e4ce](https://github.com/provusinc/quoting/commit/164e4ced66223b6ce388945c452a4080ee3de8f0))

## [1.20.0-next.17](https://github.com/provusinc/quoting/compare/v1.20.0-next.16...v1.20.0-next.17) (2022-03-02)

### Features

- **psq-1601:** filtered collaborate users based on permission set ([#772](https://github.com/provusinc/quoting/issues/772)) ([d816e15](https://github.com/provusinc/quoting/commit/d816e1506abd2db4299ebb0a724c13bb121585c1))

## [1.20.0-next.16](https://github.com/provusinc/quoting/compare/v1.20.0-next.15...v1.20.0-next.16) (2022-03-02)

### Features

- **psq-697:** logic for associated productid ([#759](https://github.com/provusinc/quoting/issues/759)) ([82a4f00](https://github.com/provusinc/quoting/commit/82a4f00f3afbc80292e8f4ff03240caf742942c5))

### Bug Fixes

- **psq-2153:** to show renamed addon text after refresh ([#766](https://github.com/provusinc/quoting/issues/766)) ([2e4ebec](https://github.com/provusinc/quoting/commit/2e4ebec48b1d34c88499f681eb4f7e220e98df75))
- **psq-2169:** removed external id reference ([#771](https://github.com/provusinc/quoting/issues/771)) ([c68a630](https://github.com/provusinc/quoting/commit/c68a630942ff21606aba521cf826fa0529814cda))

## [1.20.0-next.15](https://github.com/provusinc/quoting/compare/v1.20.0-next.14...v1.20.0-next.15) (2022-03-02)

### Bug Fixes

- add missing label definition ([fd36b01](https://github.com/provusinc/quoting/commit/fd36b019f6fd5e882659c847208a6f183712da48))

## [1.20.0-next.14](https://github.com/provusinc/quoting/compare/v1.20.0-next.13...v1.20.0-next.14) (2022-03-02)

### Bug Fixes

- **psq-2156:** renamed resource role is updated after refresh the page in summary tab ([#765](https://github.com/provusinc/quoting/issues/765)) ([4a648e3](https://github.com/provusinc/quoting/commit/4a648e3cfd2ba333e43b54d7af25b66e95a0e4c8))

## [1.20.0-next.13](https://github.com/provusinc/quoting/compare/v1.20.0-next.12...v1.20.0-next.13) (2022-03-02)

### Features

- introduce experimental feature flags ([#770](https://github.com/provusinc/quoting/issues/770)) ([6e7d7db](https://github.com/provusinc/quoting/commit/6e7d7dba408ec41e4aee728e01f4302a0a794772))

### Bug Fixes

- **estimate template:** multiple values in picklist prevents saving ([#764](https://github.com/provusinc/quoting/issues/764)) ([66d51a0](https://github.com/provusinc/quoting/commit/66d51a0ac7b811bfdba2fbca1081888714d555fd))
- **psq-2061:** incorrect section sequence in quote summary ([#760](https://github.com/provusinc/quoting/issues/760)) ([d0f7e6c](https://github.com/provusinc/quoting/commit/d0f7e6cad39cff781c653e9d02a5c1dc117ff0ef))
- **psq-2089:** updated estimate cloning for service recommendations ([#768](https://github.com/provusinc/quoting/issues/768)) ([8985ce6](https://github.com/provusinc/quoting/commit/8985ce67b95c74737299fb7714394b41edd37420))
- **psq-2167:** split resource column label ([#767](https://github.com/provusinc/quoting/issues/767)) ([b2bda69](https://github.com/provusinc/quoting/commit/b2bda69a72331707828dd35fdda10230fa8a403c))

## [1.20.0-next.12](https://github.com/provusinc/quoting/compare/v1.20.0-next.11...v1.20.0-next.12) (2022-03-01)

### Features

- **milestone:** create milestone obj and fields ([#756](https://github.com/provusinc/quoting/issues/756)) ([a77d013](https://github.com/provusinc/quoting/commit/a77d013ecb4655e8d62c497110865d00c143d0ac))

## [1.20.0-next.11](https://github.com/provusinc/quoting/compare/v1.20.0-next.10...v1.20.0-next.11) (2022-02-28)

### Bug Fixes

- **psq-1948:** hide rename role on locked section ([#762](https://github.com/provusinc/quoting/issues/762)) ([febf9f8](https://github.com/provusinc/quoting/commit/febf9f8a284c3801eab5e87a6c8cc09cc8858f2d))

## [1.20.0-next.10](https://github.com/provusinc/quoting/compare/v1.20.0-next.9...v1.20.0-next.10) (2022-02-28)

### Bug Fixes

- **psq-2069:** adjusted period values to show two decimals ([#754](https://github.com/provusinc/quoting/issues/754)) ([2d6e74a](https://github.com/provusinc/quoting/commit/2d6e74abfc1293ef8b96d1898cdd36de3669ea19))

## [1.20.0-next.9](https://github.com/provusinc/quoting/compare/v1.20.0-next.8...v1.20.0-next.9) (2022-02-27)

### Features

- **psq-1503:** add message service to flexipage ([#758](https://github.com/provusinc/quoting/issues/758)) ([2174f60](https://github.com/provusinc/quoting/commit/2174f600586a719036c0ae8cff222c301a7d2882))

## [1.20.0-next.8](https://github.com/provusinc/quoting/compare/v1.20.0-next.7...v1.20.0-next.8) (2022-02-27)

### Bug Fixes

- remove record type references from the Product2 object ([9b9e191](https://github.com/provusinc/quoting/commit/9b9e1912e477adc27ad944413cfd3ffaf5affa46))

## [1.20.0-next.7](https://github.com/provusinc/quoting/compare/v1.20.0-next.6...v1.20.0-next.7) (2022-02-27)

### Features

- **psq-1503:** manage estimates permissions and dynamic resource splits key ([#757](https://github.com/provusinc/quoting/issues/757)) ([c8354e0](https://github.com/provusinc/quoting/commit/c8354e0573b04f59fac3a5e36f1bf242be38ff42))

## [1.20.0-next.6](https://github.com/provusinc/quoting/compare/v1.20.0-next.5...v1.20.0-next.6) (2022-02-27)

### Features

- introduce the disable automatic product sync flag ([1c4056b](https://github.com/provusinc/quoting/commit/1c4056bf70c11e0598d91ae4c8b71ca5a3a2802b))
- **psq-1503:** ability to split resources ui ([#751](https://github.com/provusinc/quoting/issues/751)) ([32184b4](https://github.com/provusinc/quoting/commit/32184b4a9f981a5a7d3085ca6d08eb286dafe38a))
- **psq-697:** batch for sync products ([#753](https://github.com/provusinc/quoting/issues/753)) ([92f5df2](https://github.com/provusinc/quoting/commit/92f5df210a44c9a4c2c743b8b2b6eccdd168ee46)), closes [#739](https://github.com/provusinc/quoting/issues/739) [#755](https://github.com/provusinc/quoting/issues/755)

### Bug Fixes

- **estimate template:** user able to save task parameters without adding values ([#739](https://github.com/provusinc/quoting/issues/739)) ([ae8597f](https://github.com/provusinc/quoting/commit/ae8597fa2780213bcbf45f8ab640af84b664de50))
- **psq-2061:** sort section summaries by section display sequence ([#755](https://github.com/provusinc/quoting/issues/755)) ([55071e5](https://github.com/provusinc/quoting/commit/55071e5215fc7060a48bccd1e258a623b44ba3c4))
- re-organize grid css imports to display css correctly ([8feaaca](https://github.com/provusinc/quoting/commit/8feaaca8eda233332a95cdea5709192a931dcc41))
- set the default value of disable product sync to false ([f3665e9](https://github.com/provusinc/quoting/commit/f3665e9b656ab587bbc8f0f4927e03de9c99c01d))

## [1.20.0-next.5](https://github.com/provusinc/quoting/compare/v1.20.0-next.4...v1.20.0-next.5) (2022-02-25)

### Bug Fixes

- activity group template paths are incorrect ([#748](https://github.com/provusinc/quoting/issues/748)) ([83346bc](https://github.com/provusinc/quoting/commit/83346bc357e0d2480d12b723d872e4fb156d77e3))

## [1.20.0-next.4](https://github.com/provusinc/quoting/compare/v1.20.0-next.3...v1.20.0-next.4) (2022-02-24)

### Features

- **psq-1503:** change to master-detail ([#749](https://github.com/provusinc/quoting/issues/749)) ([0887fe5](https://github.com/provusinc/quoting/commit/0887fe56fb72539fb966ee8687a9fa8ffff51148))
- **psq-1503:** remove master-detail from permission set ([#750](https://github.com/provusinc/quoting/issues/750)) ([fd74c11](https://github.com/provusinc/quoting/commit/fd74c11bb116178ba42493946b940575b41f0435))
- **psq-1503:** resource split data model ([#746](https://github.com/provusinc/quoting/issues/746)) ([90280fd](https://github.com/provusinc/quoting/commit/90280fddbd3c1596439d6bc4811787c9f550f0f6))

## [1.20.0-next.3](https://github.com/provusinc/quoting/compare/v1.20.0-next.2...v1.20.0-next.3) (2022-02-24)

### Bug Fixes

- filter rate cards for the selected account ([#747](https://github.com/provusinc/quoting/issues/747)) ([80ff1e6](https://github.com/provusinc/quoting/commit/80ff1e60ab075788e195983c91413e6fb28c7ba0))

## [1.20.0-next.2](https://github.com/provusinc/quoting/compare/v1.20.0-next.1...v1.20.0-next.2) (2022-02-24)

### Features

- **psq-1516:** Expand/Collapse Phases in Estimate Template Tree ([#740](https://github.com/provusinc/quoting/issues/740)) ([f637206](https://github.com/provusinc/quoting/commit/f637206abea0d0cf1a88afd5e7a6a8f09f5746f1))

### Bug Fixes

- **psq-1973:** display all phase detail when clicking create/edit phases button ([#742](https://github.com/provusinc/quoting/issues/742)) ([694b552](https://github.com/provusinc/quoting/commit/694b552c54d0e811fd3b448dcdc10a90b63063ea))
- resolve security vulnerabilities around section display ([#744](https://github.com/provusinc/quoting/issues/744)) ([#745](https://github.com/provusinc/quoting/issues/745)) ([ef852da](https://github.com/provusinc/quoting/commit/ef852da7a46186c5fc65948abab5162ec910e03f))

## [1.20.0-next.1](https://github.com/provusinc/quoting/compare/v1.19.0...v1.20.0-next.1) (2022-02-22)

### Features

- **psq-1661:** removed rolledup text from rolledupestimated duration label ([#733](https://github.com/provusinc/quoting/issues/733)) ([#737](https://github.com/provusinc/quoting/issues/737)) ([86ba68a](https://github.com/provusinc/quoting/commit/86ba68a676b706619d76f5b234fc020dfd0aff96))

### [1.19.1](https://github.com/provusinc/quoting/compare/v1.19.0...v1.19.1) (2022-02-23)

### Bug Fixes

- **psq-1661:** removed rolledup text from rolledupestimated duration label ([#733](https://github.com/provusinc/quoting/issues/733)) ([412b559](https://github.com/provusinc/quoting/commit/412b559a53d8e2f0399cc64aa694a30ef6d1fd82))
- resolve security vulnerabilities around section display ([#744](https://github.com/provusinc/quoting/issues/744)) ([#745](https://github.com/provusinc/quoting/issues/745)) ([ef852da](https://github.com/provusinc/quoting/commit/ef852da7a46186c5fc65948abab5162ec910e03f))

## [1.19.0](https://github.com/provusinc/quoting/compare/v1.18.0...v1.19.0) (2022-02-22)

### Features

- **psq-1514:** ability to optionally add a phase to the estimate Temp… ([#668](https://github.com/provusinc/quoting/issues/668)) ([#714](https://github.com/provusinc/quoting/issues/714)) ([ca0698f](https://github.com/provusinc/quoting/commit/ca0698fe7e5afc4e26cc4cd14f107d714fb9ae92))
- **psq-1649:** introduced location summary to quote summaries ([#694](https://github.com/provusinc/quoting/issues/694)) ([58ae789](https://github.com/provusinc/quoting/commit/58ae789d9bf17c697610239884b6fb4b0d3c448b))
- **psq-1710:** added estimate clone button to flexi page ([#706](https://github.com/provusinc/quoting/issues/706)) ([a07b10b](https://github.com/provusinc/quoting/commit/a07b10b104fa0ef73b6a45328d62e9767b7b19b4))
- **psq-265:** ability to edit the start period of a section ([#719](https://github.com/provusinc/quoting/issues/719)) ([57d2d97](https://github.com/provusinc/quoting/commit/57d2d9776ca9750ea8825e35ac976bc012192c7f))
- **psq-265:** edit section start period spinner ([#721](https://github.com/provusinc/quoting/issues/721)) ([0290f97](https://github.com/provusinc/quoting/commit/0290f974a1dfc02f0219ce6e25bb9fa4a6e82cb9))
- **psq-335:** quote analytics section summary table ([#722](https://github.com/provusinc/quoting/issues/722)) ([fb74e09](https://github.com/provusinc/quoting/commit/fb74e096c5656cb2f588e3dc867db76dda22dc58))
- **psq-698:** created custom metadata for product mapping ([#734](https://github.com/provusinc/quoting/issues/734)) ([0f99e1d](https://github.com/provusinc/quoting/commit/0f99e1d2cd0b80d22cb9125143eeb0accb1b406f))
- **quote section:** picklist for new types ([#713](https://github.com/provusinc/quoting/issues/713)) ([06b7903](https://github.com/provusinc/quoting/commit/06b7903313ee027c6f9bbb85b7b5e1da6df2ed83))

### Bug Fixes

- build correct package version ([8511b0c](https://github.com/provusinc/quoting/commit/8511b0cd4eb0175a4f74f5ba7ad902f61ad1c640))
- **estimate template creator:** deleting all rows ([#704](https://github.com/provusinc/quoting/issues/704)) ([6aeba1a](https://github.com/provusinc/quoting/commit/6aeba1af32068a416628e808634608b1fcf53be9))
- **psq-1514:** ability to optionally add a phase to the estimate Temp… ([#668](https://github.com/provusinc/quoting/issues/668)) ([0bdee2d](https://github.com/provusinc/quoting/commit/0bdee2d85926f041ba0ba5dcdaee8686f94577f0))
- **psq-1900:** fix for summary decimal point ([#717](https://github.com/provusinc/quoting/issues/717)) ([f45eb05](https://github.com/provusinc/quoting/commit/f45eb0568ae4f23578f9c41f71fb5aa7f9952795))
- **psq-1946:** allow copy template with valid text ([#716](https://github.com/provusinc/quoting/issues/716)) ([0f1a38d](https://github.com/provusinc/quoting/commit/0f1a38db5fd08968b57f5289c3e0c74d096a15dd))
- **psq-1948:** context menu items should not show for locked sections and items ([#729](https://github.com/provusinc/quoting/issues/729)) ([7f35146](https://github.com/provusinc/quoting/commit/7f3514696256e90dd1af1256a7f1235ed193754e))
- **psq-1950:** added validation for estimate name ([#715](https://github.com/provusinc/quoting/issues/715)) ([0e7b5c0](https://github.com/provusinc/quoting/commit/0e7b5c095dc63e251863a0b292980d5fe727eca3))
- **psq-1953:** show summary time period based on quote ([#720](https://github.com/provusinc/quoting/issues/720)) ([abc4a68](https://github.com/provusinc/quoting/commit/abc4a68930b108020f1fafe0d6064bdaa66e72fd))
- **psq-1975:** updated activity groups tree view within phases ([#725](https://github.com/provusinc/quoting/issues/725)) ([07cb7d6](https://github.com/provusinc/quoting/commit/07cb7d6b9542771d64e463785e6ebcd6a5d6ad32))
- **psq-1976:** after clicking on create edit phases button it is displaying sequence field ([#728](https://github.com/provusinc/quoting/issues/728)) ([c73ff71](https://github.com/provusinc/quoting/commit/c73ff71f724b1a05e665efef47ca77b904f187a0))
- **psq-1982:** updated phase icon action based on estimate template u… ([#727](https://github.com/provusinc/quoting/issues/727)) ([4e29329](https://github.com/provusinc/quoting/commit/4e29329b3d98a8d01046a4ef3e583bfa00d8fc63))
- **psq-1985:** updated clone button label ([#726](https://github.com/provusinc/quoting/issues/726)) ([4ddffe1](https://github.com/provusinc/quoting/commit/4ddffe1947fb89f7a7874c4deac39ee5a7034d90))
- **psq-265:** shift quote item cell values left/right ([#712](https://github.com/provusinc/quoting/issues/712)) ([d2e742d](https://github.com/provusinc/quoting/commit/d2e742dc088139d6b5333b40c395465d7f05f947))
- trigger build ([58609a8](https://github.com/provusinc/quoting/commit/58609a881e9af57648c191265563dd00a3e4117b))

## [1.19.0-next.11](https://github.com/provusinc/quoting/compare/v1.19.0-next.10...v1.19.0-next.11) (2022-02-22)

### Bug Fixes

- **psq-1975:** updated activity groups tree view within phases ([#725](https://github.com/provusinc/quoting/issues/725)) ([07cb7d6](https://github.com/provusinc/quoting/commit/07cb7d6b9542771d64e463785e6ebcd6a5d6ad32))
- **psq-1982:** updated phase icon action based on estimate template u… ([#727](https://github.com/provusinc/quoting/issues/727)) ([4e29329](https://github.com/provusinc/quoting/commit/4e29329b3d98a8d01046a4ef3e583bfa00d8fc63))

## [1.19.0-next.10](https://github.com/provusinc/quoting/compare/v1.19.0-next.9...v1.19.0-next.10) (2022-02-19)

### Bug Fixes

- **psq-1948:** context menu items should not show for locked sections and items ([#729](https://github.com/provusinc/quoting/issues/729)) ([7f35146](https://github.com/provusinc/quoting/commit/7f3514696256e90dd1af1256a7f1235ed193754e))

## [1.19.0-next.9](https://github.com/provusinc/quoting/compare/v1.19.0-next.8...v1.19.0-next.9) (2022-02-18)

### Bug Fixes

- **psq-1985:** updated clone button label ([#726](https://github.com/provusinc/quoting/issues/726)) ([4ddffe1](https://github.com/provusinc/quoting/commit/4ddffe1947fb89f7a7874c4deac39ee5a7034d90))

## [1.19.0-next.8](https://github.com/provusinc/quoting/compare/v1.19.0-next.7...v1.19.0-next.8) (2022-02-18)

### Features

- **psq-335:** quote analytics section summary table ([#722](https://github.com/provusinc/quoting/issues/722)) ([fb74e09](https://github.com/provusinc/quoting/commit/fb74e096c5656cb2f588e3dc867db76dda22dc58))

### Bug Fixes

- **psq-1976:** after clicking on create edit phases button it is displaying sequence field ([#728](https://github.com/provusinc/quoting/issues/728)) ([c73ff71](https://github.com/provusinc/quoting/commit/c73ff71f724b1a05e665efef47ca77b904f187a0))

## [1.19.0-next.7](https://github.com/provusinc/quoting/compare/v1.19.0-next.6...v1.19.0-next.7) (2022-02-18)

### Features

- **psq-265:** edit section start period spinner ([#721](https://github.com/provusinc/quoting/issues/721)) ([0290f97](https://github.com/provusinc/quoting/commit/0290f974a1dfc02f0219ce6e25bb9fa4a6e82cb9))

### Bug Fixes

- **psq-1953:** show summary time period based on quote ([#720](https://github.com/provusinc/quoting/issues/720)) ([abc4a68](https://github.com/provusinc/quoting/commit/abc4a68930b108020f1fafe0d6064bdaa66e72fd))

## [1.19.0-next.6](https://github.com/provusinc/quoting/compare/v1.19.0-next.5...v1.19.0-next.6) (2022-02-17)

### Bug Fixes

- build correct package version ([8511b0c](https://github.com/provusinc/quoting/commit/8511b0cd4eb0175a4f74f5ba7ad902f61ad1c640))

## [1.19.0-next.5](https://github.com/provusinc/quoting/compare/v1.19.0-next.4...v1.19.0-next.5) (2022-02-17)

### Features

- **psq-265:** ability to edit the start period of a section ([#719](https://github.com/provusinc/quoting/issues/719)) ([57d2d97](https://github.com/provusinc/quoting/commit/57d2d9776ca9750ea8825e35ac976bc012192c7f))

### Bug Fixes

- **psq-1900:** fix for summary decimal point ([#717](https://github.com/provusinc/quoting/issues/717)) ([f45eb05](https://github.com/provusinc/quoting/commit/f45eb0568ae4f23578f9c41f71fb5aa7f9952795))
- **psq-1950:** added validation for estimate name ([#715](https://github.com/provusinc/quoting/issues/715)) ([0e7b5c0](https://github.com/provusinc/quoting/commit/0e7b5c095dc63e251863a0b292980d5fe727eca3))

## [1.19.0-next.4](https://github.com/provusinc/quoting/compare/v1.19.0-next.3...v1.19.0-next.4) (2022-02-15)

### Features

- **psq-1514:** ability to optionally add a phase to the estimate Temp… ([#668](https://github.com/provusinc/quoting/issues/668)) ([#714](https://github.com/provusinc/quoting/issues/714)) ([ca0698f](https://github.com/provusinc/quoting/commit/ca0698fe7e5afc4e26cc4cd14f107d714fb9ae92))

### Bug Fixes

- **psq-1514:** ability to optionally add a phase to the estimate Temp… ([#668](https://github.com/provusinc/quoting/issues/668)) ([0bdee2d](https://github.com/provusinc/quoting/commit/0bdee2d85926f041ba0ba5dcdaee8686f94577f0))
- **psq-1946:** allow copy template with valid text ([#716](https://github.com/provusinc/quoting/issues/716)) ([0f1a38d](https://github.com/provusinc/quoting/commit/0f1a38db5fd08968b57f5289c3e0c74d096a15dd))

## [1.19.0-next.3](https://github.com/provusinc/quoting/compare/v1.19.0-next.2...v1.19.0-next.3) (2022-02-15)

### Features

- **quote section:** picklist for new types ([#713](https://github.com/provusinc/quoting/issues/713)) ([06b7903](https://github.com/provusinc/quoting/commit/06b7903313ee027c6f9bbb85b7b5e1da6df2ed83))

### Bug Fixes

- **psq-265:** shift quote item cell values left/right ([#712](https://github.com/provusinc/quoting/issues/712)) ([d2e742d](https://github.com/provusinc/quoting/commit/d2e742dc088139d6b5333b40c395465d7f05f947))

## [1.19.0-next.2](https://github.com/provusinc/quoting/compare/v1.19.0-next.1...v1.19.0-next.2) (2022-02-12)

### Features

- **psq-1649:** introduced location summary to quote summaries ([#694](https://github.com/provusinc/quoting/issues/694)) ([58ae789](https://github.com/provusinc/quoting/commit/58ae789d9bf17c697610239884b6fb4b0d3c448b))

## [1.19.0-next.1](https://github.com/provusinc/quoting/compare/v1.18.0...v1.19.0-next.1) (2022-02-12)

### Features

- **psq-1710:** added estimate clone button to flexi page ([#706](https://github.com/provusinc/quoting/issues/706)) ([a07b10b](https://github.com/provusinc/quoting/commit/a07b10b104fa0ef73b6a45328d62e9767b7b19b4))

### Bug Fixes

- **estimate template creator:** deleting all rows ([#704](https://github.com/provusinc/quoting/issues/704)) ([6aeba1a](https://github.com/provusinc/quoting/commit/6aeba1af32068a416628e808634608b1fcf53be9))

## [1.18.0](https://github.com/provusinc/quoting/compare/v1.17.3...v1.18.0) (2022-02-11)

### Features

- **psq-1827:** updated title ([#702](https://github.com/provusinc/quoting/issues/702)) ([#709](https://github.com/provusinc/quoting/issues/709)) ([6a8ea8a](https://github.com/provusinc/quoting/commit/6a8ea8a518ca804833b3e658e0e0f370fb27a213))

## [1.6.0-next.39](https://github.com/provusinc/quoting/compare/v1.6.0-next.38...v1.6.0-next.39) (2022-02-10)

### Features

- introduce qa specific patch versions ([5a3194f](https://github.com/provusinc/quoting/commit/5a3194fd0dbc7ba76f07f0f67e8229e5c4be5848))

## [1.6.0-next.38](https://github.com/provusinc/quoting/compare/v1.6.0-next.37...v1.6.0-next.38) (2022-02-10)

### Bug Fixes

- remove headcount set scale ([#703](https://github.com/provusinc/quoting/issues/703)) ([2441344](https://github.com/provusinc/quoting/commit/24413446a0811ad587621bf46e27fb9cf747db33))

## [1.6.0-next.37](https://github.com/provusinc/quoting/compare/v1.6.0-next.36...v1.6.0-next.37) (2022-02-10)

### Bug Fixes

- incorrect time period term calculations ([#701](https://github.com/provusinc/quoting/issues/701)) ([f808de3](https://github.com/provusinc/quoting/commit/f808de3281e8b6f0c58caded42455f4cce3e032e))

## [1.6.0-next.36](https://github.com/provusinc/quoting/compare/v1.6.0-next.35...v1.6.0-next.36) (2022-02-10)

### Bug Fixes

- use a single end date calculation for all time periods ([#700](https://github.com/provusinc/quoting/issues/700)) ([e84ec2b](https://github.com/provusinc/quoting/commit/e84ec2bfd6bc5dec509e85aaa7192e8933bbe009))

## [1.6.0-next.35](https://github.com/provusinc/quoting/compare/v1.6.0-next.34...v1.6.0-next.35) (2022-02-10)

### Features

- trigger build, cleanup version ids ([5dab305](https://github.com/provusinc/quoting/commit/5dab3052a539114efdf4335df68c791bcb9624f9))

### Bug Fixes

- **psq-1827:** added error message if period count exceeds ([#693](https://github.com/provusinc/quoting/issues/693)) ([8071fd1](https://github.com/provusinc/quoting/commit/8071fd196eab3cf181fd52c81af6634e5f110388))
- **psq-1883:** margin percent shows 0 when revenue is zero ([#697](https://github.com/provusinc/quoting/issues/697)) ([17b0472](https://github.com/provusinc/quoting/commit/17b04729b5660dbb0649a13203b150d55c92fed1))

## [1.6.0-next.34](https://github.com/provusinc/quoting/compare/v1.6.0-next.33...v1.6.0-next.34) (2022-02-09)

### Bug Fixes

- **psq-1652:** missing header and footer in the Save as Template dialog ([#695](https://github.com/provusinc/quoting/issues/695)) ([1740bbf](https://github.com/provusinc/quoting/commit/1740bbf5baafcdf544c6470090bede2a2bc9dda4))

## [1.6.0-next.33](https://github.com/provusinc/quoting/compare/v1.6.0-next.32...v1.6.0-next.33) (2022-02-09)

### Bug Fixes

- the service end date is not being calculated in the dialog ([9c7b90c](https://github.com/provusinc/quoting/commit/9c7b90c7b445d7c285ad3776f4518d680c3b31b2))

## [1.6.0-next.32](https://github.com/provusinc/quoting/compare/v1.6.0-next.31...v1.6.0-next.32) (2022-02-09)

### Bug Fixes

- incorrect auto-calculated service end date for for week time period ([#696](https://github.com/provusinc/quoting/issues/696)) ([0dfc42c](https://github.com/provusinc/quoting/commit/0dfc42cc6373fe7ab84f0d77ec3190a6d53cc873))
- remove service start and calendar start time period ([5791796](https://github.com/provusinc/quoting/commit/57917960a2b75990a768846039b944494a26d4ab))

## [1.6.0-next.31](https://github.com/provusinc/quoting/compare/v1.6.0-next.30...v1.6.0-next.31) (2022-02-09)

### Bug Fixes

- allow estimate to quote activity group period end overlap ([#691](https://github.com/provusinc/quoting/issues/691)) ([fb9359c](https://github.com/provusinc/quoting/commit/fb9359cf1ba29fccf9a44bf0d30cb33fa1ae7690))

## [1.6.0-next.30](https://github.com/provusinc/quoting/compare/v1.6.0-next.29...v1.6.0-next.30) (2022-02-09)

### Features

- **psq-1650:** added grand total person period ([#690](https://github.com/provusinc/quoting/issues/690)) ([787cf3e](https://github.com/provusinc/quoting/commit/787cf3e545e2a25329da1ca84c997f8f409ae35c))

### Bug Fixes

- **psq-1829:** disable edit of adjusted unit price when item non-billable ([#685](https://github.com/provusinc/quoting/issues/685)) ([d588d35](https://github.com/provusinc/quoting/commit/d588d3502f8c15b329b3f9866f1198757e0041a8))

## [1.6.0-next.29](https://github.com/provusinc/quoting/compare/v1.6.0-next.28...v1.6.0-next.29) (2022-02-08)

### Bug Fixes

- **psq-1780:** make adjusted unit price zero when quote item non-billable ([#678](https://github.com/provusinc/quoting/issues/678)) ([87c42ec](https://github.com/provusinc/quoting/commit/87c42ec3f23be5b0818a099fe7e0b7e78c9fe007))

## [1.6.0-next.28](https://github.com/provusinc/quoting/compare/v1.6.0-next.27...v1.6.0-next.28) (2022-02-08)

### Features

- **psq-1864:** pre-populate section name in edit section dialog ([#679](https://github.com/provusinc/quoting/issues/679)) ([cc0f315](https://github.com/provusinc/quoting/commit/cc0f3156569405df58be7542093b4d6cb2b19bf3))

## [1.6.0-next.27](https://github.com/provusinc/quoting/compare/v1.6.0-next.26...v1.6.0-next.27) (2022-02-08)

### Bug Fixes

- **psq-1865:** estimate to quote resource headcount is 0 for some items ([#681](https://github.com/provusinc/quoting/issues/681)) ([cff4b9a](https://github.com/provusinc/quoting/commit/cff4b9ac30b4d5b25fa8654848569936a6ff0b13))

## [1.6.0-next.26](https://github.com/provusinc/quoting/compare/v1.6.0-next.25...v1.6.0-next.26) (2022-02-07)

### Bug Fixes

- **psq-1674:** incorrect weeks-year calculation ([#677](https://github.com/provusinc/quoting/issues/677)) ([9c7cbaf](https://github.com/provusinc/quoting/commit/9c7cbafc0776d0dc2a65347f4bdb16de9f122bb4))

## [1.6.0-next.25](https://github.com/provusinc/quoting/compare/v1.6.0-next.24...v1.6.0-next.25) (2022-02-07)

### Bug Fixes

- estimate failed to save when marking an activity group as n/a ([3e88203](https://github.com/provusinc/quoting/commit/3e88203711bdba42eccd7ef1bc61841ff2e64f42))

## [1.6.0-next.24](https://github.com/provusinc/quoting/compare/v1.6.0-next.23...v1.6.0-next.24) (2022-02-03)

### Bug Fixes

- **psq-1779:** unable to add resources to quote ([#675](https://github.com/provusinc/quoting/issues/675)) ([12cf49f](https://github.com/provusinc/quoting/commit/12cf49f61a1f38c4ad2eaf03e75840edccc4539e))

## [1.6.0-next.23](https://github.com/provusinc/quoting/compare/v1.6.0-next.22...v1.6.0-next.23) (2022-02-03)

### Features

- **psq-58:** Ability to select an account specific rate card for a quote ([#657](https://github.com/provusinc/quoting/issues/657)) ([3612924](https://github.com/provusinc/quoting/commit/3612924eee9108fc32d36ffe45b970bbeb6bbbd4))

### Bug Fixes

- **psq-1673:** 5 quarters are being added to 1 year ([#673](https://github.com/provusinc/quoting/issues/673)) ([06702e0](https://github.com/provusinc/quoting/commit/06702e0cb550374185769698f47c098c0976d936))

## [1.6.0-next.22](https://github.com/provusinc/quoting/compare/v1.6.0-next.21...v1.6.0-next.22) (2022-02-03)

### Features

- **psq-268:** allow user to make resources non-billable ([#671](https://github.com/provusinc/quoting/issues/671)) ([7477df3](https://github.com/provusinc/quoting/commit/7477df312e59d872d44f5a18ef74f788ec5b9c77))

### Bug Fixes

- **psq-1153, psq-1675:** first week period has 6 days instead of 7 ([#672](https://github.com/provusinc/quoting/issues/672)) ([093a51e](https://github.com/provusinc/quoting/commit/093a51eb8f61e2dbbdbf1e6225d6a000fead8f15))

## [1.6.0-next.21](https://github.com/provusinc/quoting/compare/v1.6.0-next.20...v1.6.0-next.21) (2022-02-02)

### Bug Fixes

- **grid:** new quote errors on load when simple sections is enabled ([#670](https://github.com/provusinc/quoting/issues/670)) ([2425679](https://github.com/provusinc/quoting/commit/2425679969a7e202b18fb2830b7a7e5cde83547f))

## [1.6.0-next.20](https://github.com/provusinc/quoting/compare/v1.6.0-next.19...v1.6.0-next.20) (2022-02-02)

### Bug Fixes

- **estimate:** level adjustments not captured on activity-level role ([#666](https://github.com/provusinc/quoting/issues/666)) ([ae1fab1](https://github.com/provusinc/quoting/commit/ae1fab1359b4405a14d8c91e9799625928392f25))

## [1.6.0-next.19](https://github.com/provusinc/quoting/compare/v1.6.0-next.18...v1.6.0-next.19) (2022-02-01)

### Features

- change the name of the copy as template button to save as template ([4f39166](https://github.com/provusinc/quoting/commit/4f391667cdd3a615680f7b4c130bee5db48ca578))

## [1.6.0-next.18](https://github.com/provusinc/quoting/compare/v1.6.0-next.17...v1.6.0-next.18) (2022-02-01)

### Bug Fixes

- increase build timeouts (trigger build) ([d0fc60a](https://github.com/provusinc/quoting/commit/d0fc60af17ccee851efb108f09e550752f9cf12b))

## [1.6.0-next.17](https://github.com/provusinc/quoting/compare/v1.6.0-next.16...v1.6.0-next.17) (2022-02-01)

### Bug Fixes

- **psq-1670:** use the schedule settings to determine the number of days in a month ([#663](https://github.com/provusinc/quoting/issues/663)) ([98519f0](https://github.com/provusinc/quoting/commit/98519f0600a9ddc754efd860874907b98cf3f82d))

## [1.6.0-next.16](https://github.com/provusinc/quoting/compare/v1.6.0-next.15...v1.6.0-next.16) (2022-02-01)

### Bug Fixes

- **psq-1692:** validate if there are any task parameter values ([#659](https://github.com/provusinc/quoting/issues/659)) ([82a0a16](https://github.com/provusinc/quoting/commit/82a0a16cda1e3e4ccb37fcea238597b5b8e489fe))
- **resource role prefs:** roles are unordered in preferences ([#660](https://github.com/provusinc/quoting/issues/660)) ([9757f32](https://github.com/provusinc/quoting/commit/9757f326e01e7f99b0dc2fd55c4120bf021fd386))

## [1.6.0-next.15](https://github.com/provusinc/quoting/compare/v1.6.0-next.14...v1.6.0-next.15) (2022-01-31)

### Features

- **estimate manager:** show tier definitions when parameter type is integer tiers ([#655](https://github.com/provusinc/quoting/issues/655)) ([43383f7](https://github.com/provusinc/quoting/commit/43383f741b8bf3cd23fe19ebd107d74afb166ed4))

## [1.6.0-next.14](https://github.com/provusinc/quoting/compare/v1.6.0-next.13...v1.6.0-next.14) (2022-01-29)

### Bug Fixes

- update package version and trigger build ([d59bdfe](https://github.com/provusinc/quoting/commit/d59bdfe717c803c2f0828d54eda6ee4fb88f4ac2))

## [1.6.0-next.13](https://github.com/provusinc/quoting/compare/v1.6.0-next.12...v1.6.0-next.13) (2022-01-28)

### Bug Fixes

- trigger build ([a8e4e67](https://github.com/provusinc/quoting/commit/a8e4e676a01ee4cf94d53ac859f53beb61549827))

### Reverts

- Revert "fix(psq-1498): make rate card field mandatory (#644)" (#656) ([c453882](https://github.com/provusinc/quoting/commit/c4538821facc83e2e45687f530525b5405ccc07f)), closes [#644](https://github.com/provusinc/quoting/issues/644) [#656](https://github.com/provusinc/quoting/issues/656)

## [1.6.0-next.12](https://github.com/provusinc/quoting/compare/v1.6.0-next.11...v1.6.0-next.12) (2022-01-28)

### Bug Fixes

- **psq-1498:** make rate card field mandatory ([#644](https://github.com/provusinc/quoting/issues/644)) ([2846f74](https://github.com/provusinc/quoting/commit/2846f7487abbbe74e006aa385ce486a6334f8320))

## [1.6.0-next.11](https://github.com/provusinc/quoting/compare/v1.6.0-next.10...v1.6.0-next.11) (2022-01-28)

### Features

- change rename section to edit section ([#653](https://github.com/provusinc/quoting/issues/653)) ([076e20d](https://github.com/provusinc/quoting/commit/076e20de2921a99ffd8ef876a2268efd581c5c48))

### Bug Fixes

- **psq-1453:** filtering out deleted values from picklist and integer tier modal ([#652](https://github.com/provusinc/quoting/issues/652)) ([d5cc361](https://github.com/provusinc/quoting/commit/d5cc361bb12e31bcf4c39cf55a35f2abc6455651))
- remove monthly time period check ([#654](https://github.com/provusinc/quoting/issues/654)) ([4af56c9](https://github.com/provusinc/quoting/commit/4af56c94ec64bdf91c9aaed5841766597354c4b7))

## [1.6.0-next.10](https://github.com/provusinc/quoting/compare/v1.6.0-next.9...v1.6.0-next.10) (2022-01-28)

### Bug Fixes

- move secrets file to workflow ([f8d8473](https://github.com/provusinc/quoting/commit/f8d84730013e0f381d7364639bd6810f56ddd9d6))

## [1.6.0-next.9](https://github.com/provusinc/quoting/compare/v1.6.0-next.8...v1.6.0-next.9) (2022-01-28)

### Bug Fixes

- test release notifications and notes ([37d1448](https://github.com/provusinc/quoting/commit/37d14486e8f9314713bd7f2bb7587f76c1c9569f))
