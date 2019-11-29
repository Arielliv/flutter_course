import 'package:flutter/material.dart';
import 'package:module_5/providers/user_places.dart';
import 'package:module_5/screens/add_place_screen.dart';
import 'package:provider/provider.dart';

class PlacesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (Text(
          'Your places',
        )),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future:
            Provider.of<UserPlaces>(context, listen: false).fetchAndSetPlaces(),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<UserPlaces>(
                child: Center(
                  child: const Text('Got no places yet, start adding some!'),
                ),
                builder: (context, userPlaces, child) =>
                    userPlaces.items.length <= 0
                        ? child
                        : ListView.builder(
                            itemCount: userPlaces.items.length,
                            itemBuilder: (context, index) => ListTile(
                              leading: CircleAvatar(
                                backgroundImage: FileImage(
                                  userPlaces.items[index].image,
                                ),
                              ),
                              title: Text(userPlaces.items[index].title),
                              subtitle: Text(
                                  userPlaces.items[index].location.address),
                              onTap: () {
                                // go to detail page
                              },
                            ),
                          ),
              ),
      ),
    );
  }
}
