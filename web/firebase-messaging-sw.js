importScripts(
  "https://www.gstatic.com/firebasejs/10.7.1/firebase-app-compat.js"
);
importScripts("/firebase-messaging-custom.js");

const channel = new BroadcastChannel("sw-messages");

const firebaseConfig = {
  apiKey: "AIzaSyBtZHHK7EN03FHb2su1Pc8mgZX8jK1dK0M",
  appId: "1:337493064108:web:dae354cf1acc7af2fc6209",
  messagingSenderId: "337493064108",
  projectId: "ystfamily-prod",
  authDomain: "ystfamily-prod.firebaseapp.com",
  storageBucket: "ystfamily-prod.appspot.com",
  measurementId: "G-R46DNJ85KR",
};

firebase.initializeApp(firebaseConfig);

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((payload) => {
  console.log("onBackgroundMessage", payload);
  console.log("Received background message ", payload);
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
  };

  return self.registration.showNotification(
    notificationTitle,
    notificationOptions
  );
});
