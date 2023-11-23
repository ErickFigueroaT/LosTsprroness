import 'package:activity_ally/Presenters/MapPresenter.dart';
import 'package:activity_ally/Presenters/PertenenciaPresenter.dart';
import 'package:activity_ally/Presenters/ActivityPresenter.dart';
import 'package:activity_ally/Views/Actividad/VistaMapa.dart';
import 'package:activity_ally/Views/Mochila/VistaPertenencia.dart';
//import 'package:activity_ally/Views/crud.dart';
import 'package:flutter/material.dart';

import 'package:activity_ally/Views/Plantilla.dart';
import 'package:activity_ally/Views/Actividad/VistaActividad.dart';

import 'package:activity_ally/Views/checklist/Checklist.dart';

class NavBarC extends StatefulWidget {
  const NavBarC({super.key});

  @override
  State<NavBarC> createState() => _NavBarCState();
}

class _NavBarCState extends State<NavBarC> {
  PageController _pageController = PageController();


  List<Widget> __screens = [
    VistaMapa(presenter: MapPresenter()),
    //ListadoPage(),
    VistaActividad(presenter: ActivityPresenter()),
    VistaPertenencia(PertenenciaPresenter())
  ];


  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(
      //title: const Text('Inicio'),
      //),
      body: PageView(
        controller: _pageController,
        children: __screens,
        onPageChanged: _onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          /*
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_notifications),
            label: 'Recordatorios',
          ),
          */
          BottomNavigationBarItem(
            icon: Icon(Icons.post_add),
            label: 'Actividades',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.backpack_outlined),
            label: 'Mochila',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(255, 2, 2, 2),
        onTap: _onItemTapped,
      ),
    );
  }
}
