const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();
const firestore = admin.firestore();

exports.onUserStatusChanged = functions.database
   .ref('/status/{uid}')
   .onUpdate(async (change, context) => {
      const eventStatus = change.after.val();
      const firestoreReference = firestore.doc('users/' + context.params.uid);
      let gc;
      firestoreReference
         .get()
         .then(documentSnapshot => {
            gc = documentSnapshot.data['game'];
         })
         .catch(e => console.log('** Error getting gc => ' + e));
      let players = [];
      firestore
         .doc('games/' + gc)
         .get()
         .then(documentSnapshot => {
            players = documentSnapshot.data['players'];
         })
         .catch(e => console.log('** Error getting players => ' + e));
      players.forEach(player => {
         if (player.userId === context.params.uid) {
            player.online = eventStatus.online;
         }
      });
      firestore.doc('games/' + gc).update({ players: players });
      const statusSnapshot = await change.after.ref.once('value');
      const status = statusSnapshot.val();
      console.log(status, eventStatus);
      eventStatus.lastChanged = new Date(eventStatus.lastChanged).toISOString();
      return firestoreReference.update(eventStatus);
   });
