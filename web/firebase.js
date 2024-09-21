// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyCx0AdlE-XHio_owRXpPZ6yxy8w4UKuXh4",
  authDomain: "jobapplyservicebd-1bda4.firebaseapp.com",
  projectId: "jobapplyservicebd-1bda4",
  storageBucket: "jobapplyservicebd-1bda4.appspot.com",
  messagingSenderId: "890086279190",
  appId: "1:890086279190:web:bddf43c0d69f5c5888cd37",
  measurementId: "G-9VYM65PJR7"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);
