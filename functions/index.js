const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();
const firestore = admin.firestore();

exports.onUserStatusChanged = functions.database
   .ref('/status/{uid}')
   .onUpdate(async (change, context) => {
      const eventStatus = change.after.val();
      const firestoreReference = firestore.doc('users/' + context.params.uid);
      firestoreReference
         .get()
         .then(documentSnapshot => {
            let gc = documentSnapshot.data()['game'];
            firestore
               .doc(`games/${gc}`)
               .get()
               .then(documentSnapshot => {
                  let players = documentSnapshot.data()['players'];
                  players.forEach(player => {
                     if (player.userId === context.params.uid) {
                        player.online = eventStatus.online;
                     }
                  });
                  firestore.doc('games/' + gc).update({ players: players });
               })
               .catch(e => console.log('** Error getting players => ' + e));
         })
         .catch(e => console.log('** Error getting gameCode => ' + e));
      eventStatus.lastChanged = new Date(eventStatus.lastChanged).toISOString();
      return firestoreReference.update(eventStatus);
   });
