'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {".git/COMMIT_EDITMSG": "cfcbf472eca4c9d1c00a27ebc1a28b18",
".git/config": "405df0b2d5af8a21b4adbe1a4d4c99f0",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/HEAD": "013f073889cb8d3d23aea2663408e9d8",
".git/hooks/applypatch-msg.sample": "ce562e08d8098926a3862fc6e7905199",
".git/hooks/commit-msg.sample": "579a3c1e12a1e74a98169175fb913012",
".git/hooks/fsmonitor-watchman.sample": "a0b2633a2c8e97501610bd3f73da66fc",
".git/hooks/post-update.sample": "2b7ea5cee3c49ff53d41e00785eb974c",
".git/hooks/pre-applypatch.sample": "054f9ffb8bfe04a599751cc757226dda",
".git/hooks/pre-commit.sample": "305eadbbcd6f6d2567e033ad12aabbc4",
".git/hooks/pre-merge-commit.sample": "39cb268e2a85d436b9eb6f47614c3cbc",
".git/hooks/pre-push.sample": "2c642152299a94e05ea26eae11993b13",
".git/hooks/pre-rebase.sample": "56e45f2bcbc8226d2b4200f7c46371bf",
".git/hooks/pre-receive.sample": "2ad18ec82c20af7b5926ed9cea6aeedd",
".git/hooks/prepare-commit-msg.sample": "2b5c047bdb474555e1787db32b2d2fc5",
".git/hooks/push-to-checkout.sample": "c7ab00c7784efeadad3ae9b228d4b4db",
".git/hooks/update.sample": "647ae13c682f7827c22f5fc08a03674e",
".git/index": "07b4544692fdafb317766d403556ca8a",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "9c0e8f1f5cd3c7091e6afa4582bb58a9",
".git/logs/refs/heads/build": "9c0e8f1f5cd3c7091e6afa4582bb58a9",
".git/logs/refs/remotes/origin/build": "4529017409c899ee87d181e30486130a",
".git/objects/04/e5efc15dc0c60ea2ffcc37c5bf25e96689f44d": "978222f47488835b92838c74cb5c684c",
".git/objects/08/48086363dbf9c0e41ffdbcb49eda56909805bc": "ae7a0f6b795b4b1e5f1aa8d765dc13f8",
".git/objects/0a/2ad3a8946718e5da80b8b36f3a970f9203bb41": "493becadfb3c0f3d60727bde4e9f1614",
".git/objects/0b/d6117a1bf3b1737325ec94ea3bac907a7e6d6e": "399b04a0b600f697582f20efe51d506b",
".git/objects/0d/bff57e869eb34067505f3a1ace21b51a8de716": "6da5316ce6c828397d5295cdeb647798",
".git/objects/0f/fe00b92b2e2d21c1f33024760f685cbb7ffdb8": "6655e717f185770489b36816ed0d52de",
".git/objects/12/5c284dc2bbed823ed6389e50cc75a8a1ef2351": "9ab0bcea773dc4fd6ef989aef459b28a",
".git/objects/14/bd806b527b958424f548726985f3ce0187a5fd": "01c1804b4421423058e8e6e817b2fd7d",
".git/objects/17/965c7f7533d2e7179938132563761bba4558a1": "4c01cb6c630fddc2d3003b6910c66846",
".git/objects/1b/427b43a7c8332ce0485804199257b1cabe6029": "61b378758c4538032423874042689d9e",
".git/objects/1c/8f5e910bfb1a4a2871eeedc6eae01ca25e7ce1": "7d52f9ae3b3fac811829018aea2c668f",
".git/objects/20/1afe538261bd7f9a38bed0524669398070d046": "82a4d6c731c1d8cdc48bce3ab3c11172",
".git/objects/20/a0cacec3dd8004723b31b1b5acd18924b5e275": "12d4fa3f06182ddb6b07111b0ea1ca27",
".git/objects/2a/bf03542c17e6f7a7806a226c3be732b51c5a40": "4593012a42df8795cd0ae089a5b7aaaf",
".git/objects/2d/fc52ee016864a7f4148eda506cc0dd1b89b5ef": "f3a8a0f11a6ea2534e8575b531ad6710",
".git/objects/33/fc6c4030944c3b7ab3622d023c7b83387da7bd": "099dfe732fdc281071060c1d9a17585a",
".git/objects/34/add7c2f1b7ef49bb7e080ca57dfe71d877a2b1": "94d9afd59d06d2d3e799ba6f952972c9",
".git/objects/35/6f65757be0f3ba0bbce32ee7b47fc5eed1c698": "90b72261e32d2ae04fb9c5b6cb808fed",
".git/objects/35/acda2fa1196aad98c2adf4378a7611dd713aa3": "b485406370fdb56248ec4e5fc074fb65",
".git/objects/39/0d080c923df14d04f223ba026a1424f8205697": "2fecd98345f3842f83d3c6778f3ec7e6",
".git/objects/3d/245a78e40b6013ddbeb7c3cab3055b51ddd9ea": "f273b736ba4ca930c96d21cf696dd265",
".git/objects/3d/c0c498bcadde1fedb10051239c50f7fbdf3553": "0ae9e6ee4a6b81bec9ea0f0cb8357e15",
".git/objects/43/e946e398d96aee466fa0aabb625f0889c3a4bd": "ac34520dee747f675e6e0a15c0bbd2be",
".git/objects/48/33fcf9ba677d3df448c90e63368e50f8bfc8d6": "a5b926fccf641f8e2a09e52478c0d37a",
".git/objects/48/9c10585b06b24f6b468738a4b0f41ccaa4293b": "e76ac578ade7ed9f803275b0dc4a37b9",
".git/objects/4f/d0e51f345ee398d4c56c9a2a36514cfdc54f3e": "d8e976b7b97437231f01681fc40815a3",
".git/objects/55/919b0b32f21410d9755ffbe64aeb2d07650744": "ffb88073b04c5f9454f1e7f08edc733c",
".git/objects/5b/b28d7f3c3f76aaab563f4583d4caa9c9784134": "8c8f1bd29f02de223663ba01f8902349",
".git/objects/5f/72e9127ffaae2a500cd9d950067f46c21b277c": "9334d3373cb9fc449377becf4cba5477",
".git/objects/67/bd84202ad5b2e307d3b6fac1731c2a5d963e0b": "aa161ace139f434c81be219b6f6205e5",
".git/objects/68/68f7bb64ba71b131690286ddc82aa0f542293e": "b6aeab417f5d5ef28ea070a09b61c7e0",
".git/objects/6a/562868741911ffc3a5345f3c094a71eb0d073d": "ad3237b80e6dc65be0e2000c6c0a445f",
".git/objects/6c/ce217ddc2efe3411dc9fa34e294e48e4cdf4f5": "8a6cc32e7f23f25e611213b06bb38448",
".git/objects/6e/cb68683477ecc5aed38ec3fc8910d9bb66276c": "8081799c6f0d89b405c8cca2b18cd6da",
".git/objects/70/15564ad166a3e9d88c82f17829f0cc01ebe29a": "b0b4eb8e40c5eaa3b07c9dcc175a4ab8",
".git/objects/7c/a97a772558495c73a93eb206eb18395333f230": "828a156adfc290ea5b7c94027dc8eb69",
".git/objects/7e/ce3282a4f7824b249d9e568819d98bd2fa3da6": "8c71b613b9912dfd1fdf473a52e99214",
".git/objects/7f/87fbfa269a3a990e7ef91a55235c4c91500c60": "657587864d2b40abca6f9ae6e538c81c",
".git/objects/82/a47d79cf59a03794d60b28309f4d0fdbe0ac64": "c587769d8734658175b548c61fef4a58",
".git/objects/86/108f3bd9bf5df15c066f97ac9978aab84c1edd": "78583210c9ebb813c590b645851cbd91",
".git/objects/88/cfd48dff1169879ba46840804b412fe02fefd6": "e42aaae6a4cbfbc9f6326f1fa9e3380c",
".git/objects/8a/aa46ac1ae21512746f852a42ba87e4165dfdd1": "1d8820d345e38b30de033aa4b5a23e7b",
".git/objects/92/9ef7c9b2caee4a9721ada287837d13a783d787": "035949c54a941cb4507a72c1eeea60e9",
".git/objects/94/8f0a5d26e899539e7821aa5a500932f76ba582": "e9093d046b81c96e5fd46a48a0b68b11",
".git/objects/96/572737cd77a534322e65361ae1df7279b34add": "3937a699db90b64f40476ded7d00d514",
".git/objects/a3/09313d5fb20765dff1d8f41dbd72c558097611": "ce77a88cc2b115d907f98afb245fa5f6",
".git/objects/a6/c3b1d56a297be4b4d48a8f54e659ed0f435b96": "04feee22291530c92d3095689adad114",
".git/objects/a7/7d01f776eccd21a85084e4974f15fd2a2d30ad": "6b9bcb16be414cbd1f70cd22b87d0a6d",
".git/objects/a8/fb3d06e5c8984c9a37745fa9306e6673136ec4": "777a8d8136c490120cdcb3e4155b76ab",
".git/objects/b3/0c6a756a3df9105f6020a63f343261ad0a3a11": "c2cfecc2c4b1b3ce29b7e569de03fbbb",
".git/objects/b4/3b712691e95f0d57550c1105d6399d9da2e53f": "d12d0be6b39b8752fedfbd09489be58e",
".git/objects/b6/19c214a6b7423f1f70f25ae330d4f78fc18c48": "cbbdbb46884602abb1376fe39e65fb52",
".git/objects/b7/49bfef07473333cf1dd31e9eed89862a5d52aa": "36b4020dca303986cad10924774fb5dc",
".git/objects/b9/2a0d854da9a8f73216c4a0ef07a0f0a44e4373": "f62d1eb7f51165e2a6d2ef1921f976f3",
".git/objects/ba/8cb00dd5231f1a55de0205c16445926a696526": "be8592f9341c9b01b70890c8614c6cf7",
".git/objects/bb/3085876799532613a08c7ebe43f24f0cc46864": "1b6aa21800d948d5513c15e54d131215",
".git/objects/c8/df92b853992397794e13e57140bbab28367e15": "4e587a7e4ba7acfc9ac1796c5c862e78",
".git/objects/cf/e2d9f8fd1f1602ac2944104150deb151250322": "138cd42be5f7f5389f94211921b22a97",
".git/objects/d6/9c56691fbdb0b7efa65097c7cc1edac12a6d3e": "868ce37a3a78b0606713733248a2f579",
".git/objects/e4/ae46c6286b2d6c6676b0c3192fc92876778498": "c1fb9fd9132eb732a1d95b1d7a283648",
".git/objects/e4/e0632f5035939b522502a3ad04e62ba03394e5": "da3d060fcad815e1acc8b34466eeb2a9",
".git/objects/eb/9b4d76e525556d5d89141648c724331630325d": "37c0954235cbe27c4d93e74fe9a578ef",
".git/objects/ee/b08d3d83bf69902bbcbedf4b0b8229cc8a132b": "06e51fca0ae702b073f98911d8718b08",
".git/objects/f5/eaf7eb1511bd9532cebfae70e47524663de109": "50b1229f40423533da8629dc65d38889",
".git/objects/f8/238828f4f1bbdf6b5ec59ef70fb16bfdfb99b4": "7b4f6b75bf8c5aa061185e4883c09c2d",
".git/objects/fa/6802c7880ed1322a9d17c64b8cd7362f93b706": "e72cd4285117c7da4ab3a6dc1f7529c8",
".git/objects/fc/963dfe2292c4e241afb5950e063414d544c093": "8cd8693ced3c797431323a7707d38029",
".git/objects/fd/b478df1e76e826040fb8fa3bcbdb5de21ac388": "a63d9c6a864dbcac98a9ca9b55709dfa",
".git/refs/heads/build": "a5e11bd3d33a0db9086754234775e387",
".git/refs/remotes/origin/build": "a5e11bd3d33a0db9086754234775e387",
"assets/AssetManifest.bin": "c02c2f8c34042ff03a415681b9ec5c8b",
"assets/AssetManifest.bin.json": "0e7f2b5e333feda497747693d0eff741",
"assets/AssetManifest.json": "046c3ca1cbc8c9afd04255abc9a4babe",
"assets/FontManifest.json": "25d9110247dae7115a89bb288f1b5ed3",
"assets/fonts/MaterialIcons-Regular.otf": "c6129844b641723fefa5f2858c460163",
"assets/images/logo.png": "761f5971d5f5139f9d8632a2e50a33c7",
"assets/NOTICES": "14a40782e03f4debbe30000fe326a9a2",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "44d5e71db3600c5a45c1753d7822201a",
"assets/packages/flutter_icons/fonts/AntDesign.ttf": "3a2ba31570920eeb9b1d217cabe58315",
"assets/packages/flutter_icons/fonts/Entypo.ttf": "744ce60078c17d86006dd0edabcd59a7",
"assets/packages/flutter_icons/fonts/EvilIcons.ttf": "140c53a7643ea949007aa9a282153849",
"assets/packages/flutter_icons/fonts/Feather.ttf": "6beba7e6834963f7f171d3bdd075c915",
"assets/packages/flutter_icons/fonts/FontAwesome.ttf": "b06871f281fee6b241d60582ae9369b9",
"assets/packages/flutter_icons/fonts/FontAwesome5_Brands.ttf": "c39278f7abfc798a241551194f55e29f",
"assets/packages/flutter_icons/fonts/FontAwesome5_Regular.ttf": "f6c6f6c8cb7784254ad00056f6fbd74e",
"assets/packages/flutter_icons/fonts/FontAwesome5_Solid.ttf": "b70cea0339374107969eb53e5b1f603f",
"assets/packages/flutter_icons/fonts/Foundation.ttf": "e20945d7c929279ef7a6f1db184a4470",
"assets/packages/flutter_icons/fonts/Ionicons.ttf": "b2e0fc821c6886fb3940f85a3320003e",
"assets/packages/flutter_icons/fonts/MaterialCommunityIcons.ttf": "3c851d60ad5ef3f2fe43ebd263490d78",
"assets/packages/flutter_icons/fonts/MaterialIcons.ttf": "a37b0c01c0baf1888ca812cc0508f6e2",
"assets/packages/flutter_icons/fonts/Octicons.ttf": "73b8cff012825060b308d2162f31dbb2",
"assets/packages/flutter_icons/fonts/SimpleLineIcons.ttf": "d2285965fe34b05465047401b8595dd0",
"assets/packages/flutter_icons/fonts/weathericons.ttf": "4618f0de2a818e7ad3fe880e0b74d04a",
"assets/packages/flutter_icons/fonts/Zocial.ttf": "5cdf883b18a5651a29a4d1ef276d2457",
"assets/packages/flutter_icons_null_safety/fonts/AntDesign.ttf": "3a2ba31570920eeb9b1d217cabe58315",
"assets/packages/flutter_icons_null_safety/fonts/Entypo.ttf": "744ce60078c17d86006dd0edabcd59a7",
"assets/packages/flutter_icons_null_safety/fonts/EvilIcons.ttf": "140c53a7643ea949007aa9a282153849",
"assets/packages/flutter_icons_null_safety/fonts/Feather.ttf": "6beba7e6834963f7f171d3bdd075c915",
"assets/packages/flutter_icons_null_safety/fonts/FontAwesome.ttf": "b06871f281fee6b241d60582ae9369b9",
"assets/packages/flutter_icons_null_safety/fonts/FontAwesome5_Brands.ttf": "c39278f7abfc798a241551194f55e29f",
"assets/packages/flutter_icons_null_safety/fonts/FontAwesome5_Regular.ttf": "f6c6f6c8cb7784254ad00056f6fbd74e",
"assets/packages/flutter_icons_null_safety/fonts/FontAwesome5_Solid.ttf": "b70cea0339374107969eb53e5b1f603f",
"assets/packages/flutter_icons_null_safety/fonts/Foundation.ttf": "e20945d7c929279ef7a6f1db184a4470",
"assets/packages/flutter_icons_null_safety/fonts/Ionicons.ttf": "b2e0fc821c6886fb3940f85a3320003e",
"assets/packages/flutter_icons_null_safety/fonts/MaterialCommunityIcons.ttf": "3c851d60ad5ef3f2fe43ebd263490d78",
"assets/packages/flutter_icons_null_safety/fonts/MaterialIcons.ttf": "a37b0c01c0baf1888ca812cc0508f6e2",
"assets/packages/flutter_icons_null_safety/fonts/Octicons.ttf": "73b8cff012825060b308d2162f31dbb2",
"assets/packages/flutter_icons_null_safety/fonts/SimpleLineIcons.ttf": "d2285965fe34b05465047401b8595dd0",
"assets/packages/flutter_icons_null_safety/fonts/weathericons.ttf": "4618f0de2a818e7ad3fe880e0b74d04a",
"assets/packages/flutter_icons_null_safety/fonts/Zocial.ttf": "5cdf883b18a5651a29a4d1ef276d2457",
"assets/shaders/ink_sparkle.frag": "4096b5150bac93c41cbc9b45276bd90f",
"canvaskit/canvaskit.js": "eb8797020acdbdf96a12fb0405582c1b",
"canvaskit/canvaskit.wasm": "64edb91684bdb3b879812ba2e48dd487",
"canvaskit/chromium/canvaskit.js": "0ae8bbcc58155679458a0f7a00f66873",
"canvaskit/chromium/canvaskit.wasm": "f87e541501c96012c252942b6b75d1ea",
"canvaskit/profiling/canvaskit.js": "c21852696bc1cc82e8894d851c01921a",
"canvaskit/profiling/canvaskit.wasm": "371bc4e204443b0d5e774d64a046eb99",
"canvaskit/skwasm.js": "87063acf45c5e1ab9565dcf06b0c18b8",
"canvaskit/skwasm.wasm": "4124c42a73efa7eb886d3400a1ed7a06",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "59a12ab9d00ae8f8096fffc417b6e84f",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "7c81824ed5761166ea8c64a744e0123c",
"/": "7c81824ed5761166ea8c64a744e0123c",
"main.dart.js": "3dd2f17d3f2af41baee926f5f2254e0b",
"manifest.json": "388e185b137f451d671fd79bfcd3b724",
"splash/style.css": "82f166bc1f89bb6b2289727b7b74de36",
"version.json": "d8d4f075170d4071ce9989c13fd78966"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
