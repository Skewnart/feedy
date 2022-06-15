import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget(
      {Key? key, required this.searchController, required this.notifyParent})
      : super(key: key);

  final Function() notifyParent;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 20),
      child: Card(
        elevation: 3,
        child: Container(
          height: 50,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                child: Icon(
                  Icons.search,
                  color: Colors.black,
                  size: 24,
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: searchController,
                  onChanged: (t) {
                    notifyParent();
                  },
                  decoration: const InputDecoration(
                    isDense: true,
                    hintText: 'Rechercher ici...',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
              if (searchController.text.isNotEmpty)
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 5),
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                    color: Colors.black,
                    iconSize: 24,
                    onPressed: () {
                      searchController.text = "";
                      notifyParent();
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
