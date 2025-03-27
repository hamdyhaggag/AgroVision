import 'package:flutter/material.dart';
import 'package:agro_vision/core/themes/app_colors.dart';
import '../../../shared/widgets/custom_appbar.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(isHome: true, title: 'Chats'),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            _buildEnhancedTabBar(),
            Expanded(
              child: TabBarView(
                children: [
                  _buildChatList(context),
                  _buildChatbotWelcome(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: const TabBar(
        dividerColor: Colors.transparent,
        indicatorColor: AppColors.primaryColor,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorWeight: 3,
        labelPadding: EdgeInsets.symmetric(vertical: 12),
        tabs: [
          Tab(text: 'Chats', icon: Icon(Icons.chat_bubble_outline)),
          Tab(text: 'Chatbot', icon: Icon(Icons.smart_toy_outlined)),
        ],
        labelColor: AppColors.primaryColor,
        unselectedLabelColor: Colors.grey,
        labelStyle: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'SYNE'),
      ),
    );
  }

  Widget _buildChatList(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 15,
      separatorBuilder: (context, index) =>
          Divider(height: 1, color: Colors.grey.shade200),
      itemBuilder: (context, index) {
        return ListTile(
          leading: const CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage('assets/images/user.png')),
          title: Text('User ${index + 1}',
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontFamily: 'SYNE')),
          subtitle: const Text('Last message preview...',
              overflow: TextOverflow.ellipsis),
          trailing: const Text('2h', style: TextStyle(color: Colors.grey)),
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          onTap: () => Navigator.pushNamed(context, '/chat-detail'),
        );
      },
    );
  }

  Widget _buildChatbotWelcome(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeaderSection(),
          _buildFeatureGrid(context),
          _buildStartButton(context),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor.withOpacity(0.1),
            AppColors.primaryColor.withOpacity(0.05)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                _buildAnimatedBackground(),
                Positioned(
                  child: Center(
                    child: Image.asset('assets/images/khedr.jpg',
                        width: 160, fit: BoxFit.contain),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Agricultural Intelligence\nAssistant',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              fontFamily: 'SYNE',
              color: AppColors.primaryColor,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'AI-powered insights for precision farming, crop optimization, and sustainable agriculture management',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: AppColors.textSecondary,
                fontFamily: 'SYNE',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return SizedBox.expand(
      child: CustomPaint(
          painter: _BackgroundDotsPainter(
              color: AppColors.primaryColor.withOpacity(0.08))),
    );
  }

  Widget _buildFeatureGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.78,
        children: const [
          _FeatureCard(
              icon: Icons.analytics_outlined,
              title: 'Crop Analysis',
              subtitle: 'Real-time plant health diagnostics'),
          _FeatureCard(
              icon: Icons.water_drop_outlined,
              title: 'Irrigation',
              subtitle: 'Smart water management'),
          _FeatureCard(
              icon: Icons.landscape_outlined,
              title: 'Soil Health',
              subtitle: 'Nutrient analysis & recommendations'),
          _FeatureCard(
              icon: Icons.pest_control_outlined,
              title: 'Pest Control',
              subtitle: 'Prevention strategies & solutions'),
        ],
      ),
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.95, end: 1.0),
          duration: const Duration(milliseconds: 200),
          builder: (context, value, child) =>
              Transform.scale(scale: value, child: child),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                    color: AppColors.primaryColor.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4))
              ],
              gradient: const LinearGradient(
                colors: [AppColors.primaryColor, AppColors.accentColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () => Navigator.pushNamed(context, '/chat-detail'),
                splashColor: Colors.white.withOpacity(0.2),
                highlightColor: Colors.transparent,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 32),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.auto_awesome_outlined,
                          size: 22, color: Colors.white),
                      SizedBox(width: 12),
                      Text(
                        'Start Smart Session',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontFamily: 'SYNE',
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FeatureCard(
      {required this.icon, required this.title, required this.subtitle});

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (e) => setState(() => _isHovered = true),
      onExit: (e) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutQuad,
        transform: Matrix4.identity()..translate(0.0, _isHovered ? -4 : 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color:
                  AppColors.primaryColor.withOpacity(_isHovered ? 0.1 : 0.05),
              blurRadius: _isHovered ? 16 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Card(
          elevation: 0,
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(14),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [AppColors.primaryColor, AppColors.accentColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Icon(widget.icon, size: 28, color: Colors.white),
                ),
                const SizedBox(height: 20),
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'SYNE',
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary.withOpacity(0.9),
                    fontFamily: 'SYNE',
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BackgroundDotsPainter extends CustomPainter {
  final Color color;

  _BackgroundDotsPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    const spacing = 40.0;
    final dotSize = 4.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), dotSize, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
