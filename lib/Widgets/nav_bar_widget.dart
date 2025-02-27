import 'package:app_camionetas_empleado/Models/vehicle.dart';
import 'package:flutter/material.dart';

class NavBarWidget extends StatefulWidget {
  final List<Vehicle> pendingVehicles;
  final void Function(int) onEditVehicle;   
  final void Function(int) onDeleteVehicle;
  final VoidCallback onSubmitAll; 


  const NavBarWidget({
    Key? key,
    required this.pendingVehicles,
    required this.onEditVehicle,
    required this.onDeleteVehicle,
    required this.onSubmitAll,
  }) : super(key: key);

  @override
  State<NavBarWidget> createState() => _NavBarWidgetState();
}

class _NavBarWidgetState extends State<NavBarWidget> {
  @override
  Widget build(BuildContext context) {
    return  Drawer(
      backgroundColor: Colors.grey[200],
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
                child: const Text(
                  'Vehiculos a enviar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              widget.pendingVehicles.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(20.0),
                    
                    child: Text(
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey
                      ),
                      'No hay vehículos pendientes',
                    ),
                  )
                : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.pendingVehicles.length,
                  itemBuilder: (context, index) {
                    final vehicle = widget.pendingVehicles[index];

                    return Card(
                      margin: EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4
                      ),
                      elevation: 2,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color.fromARGB(255, 185, 175, 175),
                          child: Text(
                            '${index +1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title:  Text(
                          vehicle.patent,
                          style: const TextStyle(
                            fontSize: 14,
                            color:Colors.black,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        subtitle: Text(
                          'Tecnico: ${vehicle.technician}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => widget.onEditVehicle(index),
                              tooltip: 'Editar',
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _confirmDelete(context, index),
                              tooltip: 'Eliminar',
                            )
                          ],
                        ),
                      
                      ),
                    );
                  },
                ),

                if (widget.pendingVehicles.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton.icon(
                    onPressed: widget.onSubmitAll,
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'ENVIAR TODOS',
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)
                      )
                      
                    ),
                  ),
                ),
            ],
          ),
        )
      ),
    );
  }

  void _confirmDelete(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Confirmar eliminacion',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),
        ),
        content: Text(
          '¿Estas seguro de eliminar el vehiculo?',
          style: TextStyle(
            fontSize: 16
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancelar',
              style: TextStyle(
                color: Colors.grey
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              widget.onDeleteVehicle(index);
              Navigator.pop(context);
            },
            child: const Text(
              'Eliminar',
              style: TextStyle(
                color: Colors.red
              ),
            )
          )

        ],
      )
    );
  }
}