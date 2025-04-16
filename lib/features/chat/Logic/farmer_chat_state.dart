import 'package:equatable/equatable.dart';

import '../models/farmer_chat_model.dart';

sealed class FarmerChatState extends Equatable {
  const FarmerChatState();

  @override
  List<Object> get props => [];
}

class FarmerChatInitial extends FarmerChatState {}

class FarmerChatLoading extends FarmerChatState {}

class FarmerChatLoaded extends FarmerChatState {
  final List<Conversation> conversations;

  const FarmerChatLoaded(this.conversations);

  @override
  List<Object> get props => [conversations];
}

class FarmerChatError extends FarmerChatState {
  final String message;

  const FarmerChatError(this.message);

  @override
  List<Object> get props => [message];
}
