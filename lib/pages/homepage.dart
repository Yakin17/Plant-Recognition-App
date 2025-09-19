import 'package:flutter/material.dart';
import 'package:plantrecognition_app/main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
String _username = '';
bool _loading = true;

@override
void initState(){
  super.initState();
  _loadUserProfile();
}

Future<void> _loadUserProfile() async{
  try{
    final user = supabase.auth.currentUser;
    if(user == null) return;

    final data = await supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

    if (mounted) {
      setState(() {
        _username = (data?['username'] ?? 'User').toString();
        _loading = false;
      });
    }

  }catch(error){
    if(mounted){
      setState(() {
        _username = 'User';
        _loading = false;
      });
    }

  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'PlantHealer',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon( Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: _loading
          ? const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF2E7D32),

            ),
          )
        :SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Message de bienvenue
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0,4),
                    )
                  ]
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back, $_username!',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Discover the healing power of plants around you',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ]
                ),
              ),

              const SizedBox(height: 24),

              //Statistiques du jour
              const Text(
                'Today\'s Insights',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height:16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatCard('Plants','12',Icons.local_florist),
                  _buildStatCard('Identified','8',Icons.check_circle),
                  _buildStatCard('Remaining', '4', Icons.schedule),
                ],
              ),

              const SizedBox(height: 24),


              //plantes recentes
              const Text(
                'Recent Medicinal Plants',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 16),
              _buildPlantCard(
                'Aloe Vera',
                'Skin heealing, Digestive aid',
                'assets/aloe_vera.png',
                '85% Match',
              ),
              const SizedBox(height: 12),
              _buildPlantCard(
                'Lavender',
                'Relaxation, Sleep aid',
                'assets/lavender.png',
                '92% Match',

              ),
            ]
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          color: Colors.white,
          surfaceTintColor: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, 'Home', true, () {}),
              _buildNavItem(Icons.camera_alt, 'Identify', false, () {
                Navigator.of(context).pushNamed('/camera');
                }),
                _buildNavItem(Icons.person, 'Profile', false, () {
                  Navigator.of(context).pushNamed('/account');
               }),

            ],
          ),
        ),
    );
  }
  
  Widget _buildNavItem(IconData icon, String label, bool isActive, VoidCallback onTap)
  {

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration:BoxDecoration(
              color: isActive ? const Color(0xFF2E7D32).withOpacity(0.1) : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isActive ? const Color(0xFF2E7D32) : Colors.grey,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? const Color(0xFF2E7D32) : Colors.grey,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,

            ),
          )
        ],
      )
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF2E7D32), size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlantCard(String name, String benefits, String image, String match) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.local_florist, color: Color(0xFF2E7D32), size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  benefits,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              match,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
          ),
        ],
      ),
    );
  }


  
}

