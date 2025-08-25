ListView.builder(
  itemCount: devices.length,
  itemBuilder: (context, index) {
    final device = devices[index];
    return ListTile(
      title: Text(device.name),
      subtitle: Text('${device.ip} | ${device.mac} | ${device.manufacturer} | ${device.type}'),
      trailing: IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () => _editDeviceName(device),
      ),
    );
  },
),
