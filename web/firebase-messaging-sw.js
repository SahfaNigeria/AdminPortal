importScripts(
  "https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js"
);
importScripts(
  "https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js"
);

firebase.initializeApp({
  apiKey: "AIzaSyCuDuhEt1hGwmKF6z8f4To8Xi4mC9guTqE",
  authDomain: "jambo-mama-nigeria.firebaseapp.com",
  projectId: "jambo-mama-nigeria",
  storageBucket: "jambo-mama-nigeria.appspot.com",
  messagingSenderId: "501778526252",
  appId: "1:501778526252:web:26735b3c7b9f244c4ea189",
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  console.log("Background notification received:", payload);
});