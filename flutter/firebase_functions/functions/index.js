const functions = require("firebase-functions");
const admin = require('firebase-admin');
admin.initializeApp();

const db = admin.firestore();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//

exports.onUpdateLesson = functions.firestore.document('/lessons/{docID}').onUpdate(async(snapshot, context) => {
    //Get lesson.
    const oldLesson = snapshot.before.data();
    const newLesson = snapshot.after.data();

    const snap = await db.collection('/sessions').where('selectedLesson.lessonCode', '==', oldLesson.lessonCode).get();
    let updatePromises = [];

    snap.forEach(doc => {
        updatePromises.push(db.collection("sessions").doc(doc.id).update({
            selectedLesson: newLesson
        }));
    })

    await Promise.all(updatePromises);
});

exports.onDeleteLesson = functions.firestore.document('/lessons/{docID}').onDelete(async(snapshot, context) => {
    //Get lesson.
    const lesson = snapshot.data();
    const snap = await db.collection('/sessions').where('selectedLesson.lessonCode', '==', lesson.lessonCode).get();
    let updatePromises = [];
    snap.forEach(doc => {
        updatePromises.push(db.collection("sessions").doc(doc.id).delete());
    })
    await Promise.all(updatePromises);
});

exports.onDeleteUser = functions.firestore.document('/users/{docID}').onDelete(async(snapshot, context) => {
    //Get User
    const user = snapshot.data();
    let updatePromises = [];

    const sessionsSnap = await db.collection('/sessions').where('selectedLesson.user.userID', '==', user.userID).get();
    sessionsSnap.forEach(doc => {
        updatePromises.push(db.collection("sessions").doc(doc.id).delete());
    });

    const lessonsSnap = await db.collection('/lessons').where('user.userID', '==', user.userID).get();
    lessonsSnap.forEach(doc => {
        updatePromises.push(db.collection("lessons").doc(doc.id).delete());
    })

    const attendanceSnap = await db.collection('/attendance').where('userID', '==', user.userID).get();
    attendanceSnap.forEach(doc => {
        updatePromises.push(db.collection("attendance").doc(doc.id).delete());
    })

    await Promise.all(updatePromises);
});

exports.onDeleteSession = functions.firestore.document('/sessions/{docID}').onDelete(async(snapshot, context) => {
    //Get session
    const session = snapshot.data();
    let updatePromises = [];

    const attendanceSnap = await db.collection('/attendance').where('sessionID', '==', session.sessionID).get();
    attendanceSnap.forEach(doc => {
        updatePromises.push(db.collection("attendance").doc(doc.id).delete());
    });

    await Promise.all(updatePromises);
});