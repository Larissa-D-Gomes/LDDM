import 'package:agendacont_app/criarcont.dart';
import 'package:agendacont_app/editcont.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/rendering.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:agendacont_app/Event.dart';

final _formKey = GlobalKey<FormState>();

class Lista extends StatefulWidget {
  @override
  String idUser;

  Lista(this.idUser);

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

  @override
  void initState() {
    selectedEvents = {};
    selectedEvents[selectedDay] = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var snap = FirebaseFirestore.instance
        .collection("contato2")
        .where('excluido', isEqualTo: false)
        .where('fk', isEqualTo: widget.idUser)
        .snapshots();
    //addEvents(snap);
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: <Widget>[
                Text(
                  "Contatos",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Text(
                  "Pesquisar",
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
            title: Text("Contatos"),
          ),
          body: TabBarView(
              children: [body(snap), pesquisa(snap), calendario(snap)]),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.red,
              elevation: 6,
              child: Icon(Icons.add),
              onPressed: () {
                print("Botão pressionado!");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext) => NovoCont(widget.idUser)));
              }),
        ));
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

  pesquisa(var snap) {
    if (r == null || r.length == 0)
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: EdgeInsets.only(left: 40),
              width: 170,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                          labelText: "Pesquisar:", hintText: "Digite o nome"),
                      controller: _controllerPesquisa,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 5, top: 20),
                    height: 30,
                    width: 50,
                    // ignore: deprecated_member_use
                    child: RaisedButton(
                      color: Colors.deepOrange,
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 15.0,
                      ),
                      onPressed: () {
                        pesquisar();
                      },
                    ),
                  ),
                ],
              )),
        ],
      );
    else
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            margin: EdgeInsets.only(left: 40),
            width: 170,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                        labelText: "Pesquisar:", hintText: "Digite o nome"),
                    controller: _controllerPesquisa,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 5, top: 20),
                  height: 30,
                  width: 50,
                  // ignore: deprecated_member_use
                  child: RaisedButton(
                    color: Colors.deepOrange,
                    child: Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 15.0,
                    ),
                    onPressed: () {
                      pesquisar();
                    },
                  ),
                ),
              ],
            )),
        Flexible(
            child: ListView.builder(
          itemCount: r.length,
          itemBuilder: (context, index) {
            var item = r[index];
            return Container(
                padding: EdgeInsets.only(top: 12, left: 16, right: 16),
                child: Column(children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        item['img'] == null
                            ? Container(
                                margin: EdgeInsets.only(top: 0),
                                width: 50.0,
                                height: 50.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey,
                                ))
                            : Container(
                                margin: EdgeInsets.only(top: 0),
                                width: 50.0,
                                height: 50.0,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image:
                                            Image.network(item['img']).image))),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: TextButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                              title: Text(item['nome']),
                                              content: Container(
                                                height: 330,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Data de Nascimento: ",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Container(
                                                      child: Text(
                                                        item['data'],
                                                        style: TextStyle(
                                                          color:
                                                              Colors.blueGrey,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                    Text(
                                                      "Endereço: ",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Container(
                                                      child: Text(
                                                        "Logradouro:  " +
                                                            item['logradouro'] +
                                                            "\nNúmero:  " +
                                                            item['numero'] +
                                                            "\nBairro:  " +
                                                            item['bairro'] +
                                                            "\nCidade:  " +
                                                            item['localidade'] +
                                                            "\nUF:  " +
                                                            item['UF'],
                                                        style: TextStyle(
                                                          color:
                                                              Colors.blueGrey,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                    Text(
                                                      "CEP: ",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      item['CEP'],
                                                      style: TextStyle(
                                                        color: Colors.blueGrey,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                    Text(
                                                      "Telefone: ",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      item['telefone'],
                                                      style: TextStyle(
                                                        color: Colors.blueGrey,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                    Text(
                                                      "E-mail: ",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      item['email'],
                                                      style: TextStyle(
                                                        color: Colors.blueGrey,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                      "Fechar",
                                                    ))
                                              ]);
                                        });
                                  },
                                  child: Text(
                                    item['nome'],
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 18,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
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
                                  color: Colors.deepOrange,
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 20.0,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext) =>
                                                EditCont(item)));
                                  },
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(5),
                                height: 50,
                                width: 50,
                                // ignore: deprecated_member_use
                                child: RaisedButton(
                                  color: Colors.deepOrange,
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                    size: 20.0,
                                  ),
                                  onPressed: () async {
                                    item.reference.update({'excluido': true});
                                  },
                                ),
                              ),
                            ])
                      ]),
                  Divider(color: Colors.black),
                ]));
          },
        ))
      ]);
    /*return */
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
          return Center(child: Text('Nenhum Contato'));
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
                        item['img'] == null
                            ? Container(
                                margin: EdgeInsets.only(top: 0),
                                width: 50.0,
                                height: 50.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey,
                                ))
                            : Container(
                                margin: EdgeInsets.only(top: 0),
                                width: 50.0,
                                height: 50.0,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image:
                                            Image.network(item['img']).image))),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: TextButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                              title: Text(item['nome']),
                                              content: Container(
                                                height: 330,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Data de Nascimento: ",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Container(
                                                      child: Text(
                                                        item['data'],
                                                        style: TextStyle(
                                                          color:
                                                              Colors.blueGrey,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                    Text(
                                                      "Endereço: ",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Container(
                                                      child: Text(
                                                        "Logradouro:  " +
                                                            item['logradouro'] +
                                                            "\nNúmero:  " +
                                                            item['numero'] +
                                                            "\nBairro:  " +
                                                            item['bairro'] +
                                                            "\nCidade:  " +
                                                            item['localidade'] +
                                                            "\nUF:  " +
                                                            item['UF'],
                                                        style: TextStyle(
                                                          color:
                                                              Colors.blueGrey,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                    Text(
                                                      "CEP: ",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      item['CEP'],
                                                      style: TextStyle(
                                                        color: Colors.blueGrey,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                    Text(
                                                      "Telefone: ",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      item['telefone'],
                                                      style: TextStyle(
                                                        color: Colors.blueGrey,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                    Text(
                                                      "E-mail: ",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      item['email'],
                                                      style: TextStyle(
                                                        color: Colors.blueGrey,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                      "Fechar",
                                                    ))
                                              ]);
                                        });
                                  },
                                  child: Text(
                                    item['nome'],
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 18,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
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
                                  color: Colors.deepOrange,
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 20.0,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext) =>
                                                EditCont(item)));
                                  },
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(5),
                                height: 50,
                                width: 50,
                                // ignore: deprecated_member_use
                                child: RaisedButton(
                                  color: Colors.deepOrange,
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                    size: 20.0,
                                  ),
                                  onPressed: () async {
                                    item.reference.update({'excluido': true});
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

  pesquisar() async {
    print(_controllerPesquisa.text);
    var aux = (await FirebaseFirestore.instance
            .collection("contato2")
            .where('excluido', isEqualTo: false)
            .where("nome", isEqualTo: _controllerPesquisa.text)
            .where('fk', isEqualTo: widget.idUser)
            .get())
        .docs;

    setState(() {
      r = aux;

      this._loading = false;
    });
    print(r.length);
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
