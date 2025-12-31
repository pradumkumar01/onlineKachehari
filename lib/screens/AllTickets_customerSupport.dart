import 'package:flutter/material.dart';
import 'package:flutter_online_kachehari/provider/theme.dart';
import 'package:flutter_online_kachehari/models/ticket_model.dart';
import 'package:flutter_online_kachehari/services/ticket_service.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AllticketsCustomersupport extends StatefulWidget {
  const AllticketsCustomersupport({super.key});

  @override
  State<AllticketsCustomersupport> createState() =>
      _AllticketsCustomersupportState();
}

class _AllticketsCustomersupportState extends State<AllticketsCustomersupport> {
  final TicketService _ticketService = TicketService();
  String _selectedFilter = 'All'; // All, Pending, In Progress, Resolved

  @override
  Widget build(BuildContext context) {
    var themeData = Provider.of<ThemeProviderState>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: const Text(
          "All Tickets",
          style: TextStyle(
            fontFamily: "serif",
            fontSize: 21,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(color: Colors.deepPurple),
        ),
        actions: [
          // Filter dropdown
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onSelected: (value) {
              setState(() {
                _selectedFilter = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'All', child: Text('All')),
              const PopupMenuItem(value: 'Pending', child: Text('Pending')),
              const PopupMenuItem(
                  value: 'In Progress', child: Text('In Progress')),
              const PopupMenuItem(value: 'Resolved', child: Text('Resolved')),
            ],
          ),
        ],
      ),
      body: Container(
        color: themeData.isDarkMode ? Colors.black : Colors.white,
        child: StreamBuilder<List<TicketModel>>(
          stream: _selectedFilter == 'All'
              ? _ticketService.getUserTickets()
              : _ticketService.getTicketsByStatus(_selectedFilter),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 60, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading tickets',
                      style: TextStyle(
                        fontSize: 18,
                        color:
                            themeData.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            final tickets = snapshot.data ?? [];

            if (tickets.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox_outlined,
                        size: 80,
                        color: themeData.isDarkMode
                            ? Colors.white54
                            : Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      _selectedFilter == 'All'
                          ? 'No tickets yet'
                          : 'No $_selectedFilter tickets',
                      style: TextStyle(
                        fontSize: 20,
                        color:
                            themeData.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Your support tickets will appear here',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: tickets.length,
              separatorBuilder: (context, index) => Divider(
                color: themeData.isDarkMode
                    ? Colors.deepPurpleAccent
                    : Colors.grey,
                height: 1,
              ),
              itemBuilder: (context, index) {
                final ticket = tickets[index];
                final statusColor = _getStatusColor(ticket.status);

                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 5,
                  shadowColor: themeData.isDarkMode
                      ? Colors.deepPurpleAccent
                      : Colors.deepPurple,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Icon(
                      _getStatusIcon(ticket.status),
                      size: 40,
                      color: statusColor,
                    ),
                    title: Text(
                      ticket.title,
                      style: const TextStyle(
                        fontFamily: "serif",
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          'Reason: ${ticket.reason}',
                          style: const TextStyle(
                            fontFamily: "serif",
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          ticket.message,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: "serif",
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Created: ${_formatDate(ticket.createdAt)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    trailing: Chip(
                      label: Text(
                        ticket.status,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      backgroundColor: statusColor,
                    ),
                    onTap: () => _showTicketDetails(context, ticket),
                    onLongPress: () => _showDeleteConfirmation(context, ticket),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Resolved':
        return Colors.green;
      case 'In Progress':
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Resolved':
        return Icons.check_circle;
      case 'In Progress':
        return Icons.hourglass_empty;
      default:
        return Icons.pending;
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy - hh:mm a').format(date);
  }

  void _showTicketDetails(BuildContext context, TicketModel ticket) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(ticket.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Status', ticket.status),
              const SizedBox(height: 8),
              _buildDetailRow('Reason', ticket.reason),
              const SizedBox(height: 8),
              const Text(
                'Message:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(ticket.message),
              const SizedBox(height: 12),
              _buildDetailRow('Created', _formatDate(ticket.createdAt)),
              const SizedBox(height: 4),
              _buildDetailRow('Updated', _formatDate(ticket.updatedAt)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          if (ticket.status != 'Resolved')
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showDeleteConfirmation(context, ticket);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Expanded(child: Text(value)),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context, TicketModel ticket) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Ticket'),
        content: Text('Are you sure you want to delete "${ticket.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await _ticketService.deleteTicket(ticket.id);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Ticket deleted successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString().replaceAll('Exception: ', '')),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
