import '../models/farmer_chat_model.dart';

abstract class FarmerChatState {}

class FarmerChatInitial extends FarmerChatState {}

class FarmerChatLoading extends FarmerChatState {}

class FarmerChatLoaded extends FarmerChatState {
  final List<Conversation> conversations;
  final bool isOptimistic;

  FarmerChatLoaded(this.conversations, {this.isOptimistic = false});
}

class FarmerChatError extends FarmerChatState {
  final String errorMessage;

  FarmerChatError(this.errorMessage);
}
