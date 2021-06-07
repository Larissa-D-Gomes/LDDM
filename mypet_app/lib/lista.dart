import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:agendacont_app/Event.dart';

final _formKey = GlobalKey<FormState>();

class Lista extends StatefulWidget {
  @override
  String idUser;
  String idPet;

  Lista(this.idUser, this.idPet);

  _Lista createState() => _Lista();
}

class _Lista extends State<Lista> {
  TextEditingController _controllerPesquisa = TextEditingController();
  List<DocumentSnapshot> r = null;
  bool _loading = true;
  Map<DateTime, List<Event>> selectedEvents;
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  static final LatLng _kMapCenter =
  LatLng(19.018255973653343, 72.84793849278007);
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerUltima = TextEditingController();
  TextEditingController _controllerProxima = TextEditingController();

  static final CameraPosition _kInitialPosition =
  CameraPosition(target: _kMapCenter, zoom: 11.0, tilt: 0, bearing: 0);
  GoogleMapController _controller;

  @override
  void initState() {
    print(widget.idUser + widget.idPet);
    selectedEvents = {};
    selectedEvents[selectedDay] = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var snap = FirebaseFirestore.instance
        .collection("eventos")
        .where('pk', isEqualTo: widget.idUser + widget.idPet)
        .snapshots();
    //addEvents(snap);
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: <Widget>[
                Text(
                  "Eventos",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Text(
                  "Onde ir",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Text(
                  "Calendário",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            title: Text("MyPet  \u{1F43E}"),
          ),
          body: TabBarView(
              children: [body(snap), map(snap), calendario(snap)]),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.lightGreen,
              elevation: 6,
              child: Icon(Icons.add),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Adicionar evento: ",
                            style: TextStyle(fontSize: 15)),
                        content: Container(height: 200, child: form()),
                        actions: <Widget>[
                          TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                              child: Text("Cancelar")),
                          TextButton(
                              onPressed: () async {
                                bool formOk = _formKey.currentState.validate();
                                if (formOk) {
                                  await FirebaseFirestore.instance.collection('eventos').add({
                                    'nome': _controllerNome.text,
                                    'ultima': _controllerUltima.text,
                                    'proxima': _controllerProxima.text,
                                    'pk': widget.idUser + widget.idPet,
                                  });
                                  Navigator.pop(context);
                                }
                              },
                              child: Text("Salvar")),
                        ],
                      );
                    });
              }),
        ));
  }

  form() {
    return Form(
      //consegue armazenar o estado dos campos de texto e além disso, fazer a validação
      key: _formKey, //estado do formulário
      child: ListView(
        padding: EdgeInsets.all(0),
        children: <Widget>[
          TextFormField(
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
            ),
            decoration: InputDecoration(
                labelText: "Nome:", hintText: "Digite o nome do evento."),
            controller: _controllerNome,
            validator: (String text) {
              if (text.isEmpty) {
                return "Digite o nome";
              }
              return null;
            },
          ),
          TextFormField(
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
            ),
            decoration: InputDecoration(
                labelText: "Última dose:", hintText: "Digite o valor da última dose"),
            controller: _controllerUltima,
            keyboardType: TextInputType.datetime,
            validator: (String text) {
              if (text.length == 0) {
                return "Digite o valor da última dose";
              }

              return null;
            },
          ),
          TextFormField(
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
            ),
            decoration: InputDecoration(
                labelText: "Próxima dose:", hintText: "Digite o valor da próxima dose"),
            controller: _controllerProxima,
            keyboardType: TextInputType.datetime,
            validator: (String text) {


              return null;
            },
          ),
        ],
      ),
    );
  }

  formDate() {
    return Form(
      //consegue armazenar o estado dos campos de texto e além disso, fazer a validação
      key: _formKey, //estado do formulário
      child: ListView(
        padding: EdgeInsets.all(0),
        children: <Widget>[
          TextFormField(
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
            ),
            decoration: InputDecoration(
                labelText: "Última dose:", hintText: "Digite o valor da última dose"),
            controller: _controllerUltima,
            keyboardType: TextInputType.datetime,
            validator: (String text) {
              if (text.length == 0) {
                return "Digite o valor da última dose";
              }

              return null;
            },
          ),
          TextFormField(
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
            ),
            decoration: InputDecoration(
                labelText: "Próxima dose:", hintText: "Digite o valor da próxima dose"),
            controller: _controllerProxima,
            keyboardType: TextInputType.datetime,
            validator: (String text) {


              return null;
            },
          ),
        ],
      ),
    );
  }

  calendario(var snap) {
    if (selectedEvents[selectedDay] == null ||
        selectedEvents[selectedDay].length == 0)
      return Column(
        children: [
          TableCalendar(
            focusedDay: selectedDay,
            firstDay: DateTime(1990),
            lastDay: DateTime(2050),
            calendarFormat: format,
            onFormatChanged: (CalendarFormat _format) {
              setState(() {
                format = _format;
              });
            },
            startingDayOfWeek: StartingDayOfWeek.sunday,
            daysOfWeekVisible: true,

            //Day Changed
            onDaySelected: (DateTime selectDay, DateTime focusDay) {
              setState(() {
                selectedDay = selectDay;
                focusedDay = focusDay;
              });
              addEvents(snap);
              //  print(selectedEvents[selectedDay][0].title);
              // print(focusedDay);
            },
            selectedDayPredicate: (DateTime date) {
              return isSameDay(selectedDay, date);
            },

            eventLoader: _getEventsfromDay,

            //To style the Calendar
            calendarStyle: CalendarStyle(
              isTodayHighlighted: true,
              selectedDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              selectedTextStyle: TextStyle(color: Colors.white),
              todayDecoration: BoxDecoration(
                color: Colors.purpleAccent,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              defaultDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              weekendDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: true,
              titleCentered: true,
              formatButtonShowsNext: false,
              formatButtonDecoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(5.0),
              ),
              formatButtonTextStyle: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      );

    print(selectedEvents[selectedDay].length);
    return Column(
      children: [
        TableCalendar(
          focusedDay: selectedDay,
          firstDay: DateTime(1990),
          lastDay: DateTime(2050),
          calendarFormat: format,
          onFormatChanged: (CalendarFormat _format) {
            setState(() {
              format = _format;
            });
          },
          startingDayOfWeek: StartingDayOfWeek.sunday,
          daysOfWeekVisible: true,

          //Day Changed
          onDaySelected: (DateTime selectDay, DateTime focusDay) {
            setState(() {
              selectedDay = selectDay;
              focusedDay = focusDay;
            });
            addEvents(snap);
            //  print(selectedEvents[selectedDay][0].title);
            // print(focusedDay);
          },
          selectedDayPredicate: (DateTime date) {
            return isSameDay(selectedDay, date);
          },

          eventLoader: _getEventsfromDay,

          //To style the Calendar
          calendarStyle: CalendarStyle(
            isTodayHighlighted: true,
            selectedDecoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5.0),
            ),
            selectedTextStyle: TextStyle(color: Colors.white),
            todayDecoration: BoxDecoration(
              color: Colors.purpleAccent,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5.0),
            ),
            defaultDecoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5.0),
            ),
            weekendDecoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          headerStyle: HeaderStyle(
            formatButtonVisible: true,
            titleCentered: true,
            formatButtonShowsNext: false,
            formatButtonDecoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(5.0),
            ),
            formatButtonTextStyle: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        Container(
            child: Text("\nAniversariantes:",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ))),
        Flexible(
            child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: selectedEvents[selectedDay].length,
                itemBuilder: (BuildContext context, int index) {
                  return Expanded(
                      child: Container(
                    //margin: ,
                    height: 50,
                    child: Expanded(
                        child: Center(
                            child: Text(
                      selectedEvents[selectedDay][index].title + "\n",
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 25,
                      ),
                    ))),
                  ));
                }))
      ],
    );
  }

  map(var snap) {
    return GoogleMap(
      initialCameraPosition: _kInitialPosition,
      onMapCreated: onMapCreated,
      myLocationEnabled: true,
     // useCurrentLocation: true,
     // selectInitialPosition: true,
    );
    /*return */
  }


  void onMapCreated(GoogleMapController controller) async {
    _controller = controller;
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
    _controller.setMapStyle(value);
    myLocationEnabled: true;
  }

  body(var snap) {
    return StreamBuilder(
      stream: snap,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.data.docs.length == 0) {
          return Center(child: Text('Nenhum Evento'));
        }
        //addEvents(snapshot);
        return ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            var item = snapshot.data.docs[index];
            return Container(
                padding: EdgeInsets.only(top: 12, left: 16, right: 16),
                child: Column(children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(

                                  child: Text(
                                    item['nome'],
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 18,

                                    ),
                                  ),
                                ),
                              Row(
                                children: [
                                  Text(
                                    "Última dose: ",
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 13,

                                    ),
                                  ),
                                  Text(
                                    item['ultima'],
                                    style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontSize: 13,

                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Próxima dose: ",
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 13,

                                    ),
                                  ),
                                  Text(
                                    item['proxima'],
                                    style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontSize: 13,

                                    ),
                                  ),
                                ],
                              )


                            ]),
                        Spacer(),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.all(5),
                                height: 50,
                                width: 50,
                                // ignore: deprecated_member_use
                                child: RaisedButton(
                                  color: Colors.lightGreen,
                                  child: Icon(
                                    Icons.edit,
                                    size: 20.0,
                                  ),
                                  onPressed: () {
                                    edit(item);
                                  },
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(5),
                                height: 50,
                                width: 50,
                                // ignore: deprecated_member_use
                                child: RaisedButton(
                                  color: Colors.lightGreen,
                                  child: Icon(
                                    Icons.assignment_turned_in_outlined,
                                    size: 20.0,
                                  ),
                                  onPressed: () async {
                                    update(item);
                                  },
                                ),
                              ),
                            ])
                      ]),
                  Divider(color: Colors.black),
                ]));
          },
        );
      },
    );
  }

  edit(var item){
    _controllerNome.text = item['nome'];
    _controllerUltima.text = item['ultima'];
    _controllerProxima.text = item['proxima'];
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Editar',
                style: TextStyle(fontSize: 15)),
            content: Container(height: 200, child: form()),
            actions: <Widget>[
              TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: Text("Cancelar")),
              TextButton(
                  onPressed: () async {
                    bool formOk = _formKey.currentState.validate();
                    if (formOk) {
                      await item.reference.update({
                        'ultima': _controllerUltima.text,
                        'proxima': _controllerProxima.text,
                        'nome': _controllerNome.text,
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: Text("Salvar")),
            ],
          );
        });
  }

  update(var item){
    _controllerUltima.text = item['proxima'];
    _controllerProxima.text = '';
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(item['nome'],
                style: TextStyle(fontSize: 15)),
            content: Container(height: 200, child: formDate()),
            actions: <Widget>[
              TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: Text("Cancelar")),
              TextButton(
                  onPressed: () async {
                    bool formOk = _formKey.currentState.validate();
                    if (formOk) {
                      await item.reference.update({
                        'ultima': _controllerUltima.text,
                        'proxima': _controllerProxima.text,
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: Text("Salvar")),
            ],
          );
        });
  }

  void addEvents(snap) async {
    var aux = (await FirebaseFirestore.instance
            .collection("contato2")
            .where('excluido', isEqualTo: false)
            .where('fk', isEqualTo: widget.idUser)
            .get())
        .docs;
    selectedEvents[selectedDay] = [];
    for (int i = 0; i < aux.length; i++) {
      var x = aux[i]['data'].split('/');
      print(x[2] + x[1] + x[0]);
      print(selectedDay.day.toString() +
          " " +
          selectedDay.month.toString() +
          " " +
          int.parse(x[0]).toString() +
          " " +
          int.parse(x[1]).toString());
      var date = DateTime.parse(x[2] + x[1] + x[0]);

      if (selectedDay.day == int.parse(x[0]) &&
          selectedDay.month == int.parse(x[1])) {
        print('ENTROU IF');
        setState(() {
          if (!selectedEvents[selectedDay]
              .contains(Event(title: aux[i]['nome']))) {
            print("add dnv");
            selectedEvents[selectedDay].add(new Event(title: aux[i]['nome']));
            print(selectedEvents[selectedDay]);
            print(selectedEvents[selectedDay].length);
          }
        });
      }
    }
  }

  List<Event> _getEventsfromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }
}
