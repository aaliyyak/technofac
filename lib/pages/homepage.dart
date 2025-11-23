import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const routeName = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  final List<String> _categories = ['All', 'Work', 'Personal', 'Ideas', 'Todo'];
  String _selectedCategory = 'All';
  final List<String> _items = List.generate(12, (i) => 'Item ${i + 1}');

  Future<void> _refresh() async {
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() {
      // Placeholder: normally refresh data from API/local DB
    });
  }

  void _onNavTap(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                )
              : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          isDense: true,
          filled: true,
        ),
        onChanged: (_) => setState(() {}),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final selected = cat == _selectedCategory;
          return ChoiceChip(
            label: Text(cat),
            selected: selected,
            onSelected: (_) => setState(() => _selectedCategory = cat),
          );
        },
      ),
    );
  }

  Widget _buildGrid() {
    final filtered = _items
        .where((it) =>
            _selectedCategory == 'All' ||
            it.toLowerCase().contains(_selectedCategory.toLowerCase()))
        .where((it) =>
            _searchController.text.isEmpty ||
            it.toLowerCase().contains(_searchController.text.toLowerCase()))
        .toList();

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final title = filtered[index];
        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Tapped $title')),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Icon(
                      Icons.insert_drive_file,
                      size: 40,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Subtitle or brief description',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const ListTile(
              leading: CircleAvatar(child: Icon(Icons.person)),
              title: Text('User Name'),
              subtitle: Text('user@example.com'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              selected: true,
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () => Navigator.pop(context),
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign out'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const title = 'Home';
    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          )
        ],
      ),
      drawer: _buildDrawer(),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            _buildCategoryChips(),
            const SizedBox(height: 8),
            Expanded(child: _buildGrid()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // add new item
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Create new item')),
          );
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
