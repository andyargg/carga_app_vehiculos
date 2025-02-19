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
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: const Text(
                  'Vehiculos a enviar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              widget.pendingVehicles.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('No hay vehículos pendientes'),
                  )
                : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.pendingVehicles.length,
                  itemBuilder: (context, index) {
                    final vehicle = widget.pendingVehicles[index];

                    return ListTile(
                      leading: CircleAvatar(
                        child: Text('${index +1}'),
                      ),
                      title:  Text(vehicle.patent),
                      subtitle: Text('Tecnico: ${vehicle.technician}'),
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
                            onPressed: () => widget.onDeleteVehicle(index),
                            tooltip: 'Eliminar',
                          )
                        ],
                      ),

                    );
                  },
                ),

                if (widget.pendingVehicles.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton.icon(
                    onPressed: widget.onSubmitAll,
                    icon: const Icon(Icons.send),
                    label: const Text('ENVIAR TODOS'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
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
        title: const Text('Confirmar eliminacion'),
        content: Text('¿Estas seguro de eliminar el vehiculo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('cancelar'),
          ),
          TextButton(
            onPressed: () {
              widget.onDeleteVehicle(index);
              Navigator.pop(context);
            },
            child: const Text('Eliminar')
          )

        ],
      )
    );
  }
}