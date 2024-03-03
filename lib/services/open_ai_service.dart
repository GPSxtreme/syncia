import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/foundation.dart';
import 'package:syncia/errors/exception_message.dart';

class OpenAiService {
  static List<OpenAIModelModel> models = [];

  static Future<void> init() async {
    models = await OpenAI.instance.model.list();
  }

  /// Returns the model with the given id
  static Future<OpenAIModelModel> retrieveModel(String id) async {
    return await OpenAI.instance.model.retrieve(id);
  }

  /// Returns the completion model with the given ids
  static Future<OpenAICompletionModel> getCompletion(
      String prompt, String model) async {
    return await OpenAI.instance.completion.create(
      model: model,
      prompt: prompt,
      maxTokens: 20,
      temperature: 0.5,
      n: 1,
      echo: true,
    );
  }

  /// Returns the stream completion model with the given id
  static Future<Stream<OpenAIStreamCompletionModel>> streamCompletion(
      String prompt, String model) async {
    return OpenAI.instance.completion.createStream(
      model: model,
      prompt: prompt,
      maxTokens: 100,
      temperature: 0.5,
      topP: 1,
    );
  }

  /// Returns the chat completion model with the given id and chat history
  static Future<OpenAIChatCompletionModel?> chatCompletionWithHistory(
    String content,
    String model,
    List<OpenAIChatCompletionChoiceMessageModel> currentChatHistory,
  ) async {
    try {
      // Add the new user message to the provided chat history
      currentChatHistory.add(
        OpenAIChatCompletionChoiceMessageModel(
          content: <OpenAIChatCompletionChoiceMessageContentItemModel>[
            OpenAIChatCompletionChoiceMessageContentItemModel.text(content)
          ],
          role: OpenAIChatMessageRole.user,
        ),
      );
      var response = await OpenAI.instance.chat.create(
        model: model,
        messages: currentChatHistory,
      );

      return response;
    } on RequestFailedException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw ExceptionMessage('Error fetching response');
    }
  }

  /// Returns the chat completion model with the given prompt
  static Future<OpenAIChatCompletionModel> chatCompletion(
    String content,
    String model,
  ) async {
    return await OpenAI.instance.chat.create(
      model: model,
      messages: [
        OpenAIChatCompletionChoiceMessageModel(
          content: <OpenAIChatCompletionChoiceMessageContentItemModel>[
            OpenAIChatCompletionChoiceMessageContentItemModel.text(content)
          ],
          role: OpenAIChatMessageRole.user,
        ),
      ],
    );
  }

  /// Returns the stream chat completion model with the given id
  static Future<Stream<OpenAIStreamChatCompletionModel>> streamChatCompletion(
      String prompt, String model) async {
    return OpenAI.instance.chat.createStream(model: model, messages: [
      OpenAIChatCompletionChoiceMessageModel(
        content: <OpenAIChatCompletionChoiceMessageContentItemModel>[
          OpenAIChatCompletionChoiceMessageContentItemModel.text(prompt)
        ],
        role: OpenAIChatMessageRole.user,
      )
    ]);
  }

  /// Returns the stream chat completion model with the given id
  static Future<Stream<OpenAIStreamChatCompletionModel>?>
      streamChatCompletionWithHistory(
          String prompt,
          String model,
          List<OpenAIChatCompletionChoiceMessageModel>
              currentChatHistory) async {
    try {
      // Add the new user message to the provided chat history
      currentChatHistory.add(
        OpenAIChatCompletionChoiceMessageModel(
          content: <OpenAIChatCompletionChoiceMessageContentItemModel>[
            OpenAIChatCompletionChoiceMessageContentItemModel.text(prompt)
          ],
          role: OpenAIChatMessageRole.user,
        ),
      );
      var stream = OpenAI.instance.chat
          .createStream(model: model, messages: currentChatHistory);

      return stream;
    } on RequestFailedException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw ExceptionMessage("Error fetching response");
    }
  }

  /// Generates based on the given [prompt]
  /// [count] defines the number of images to be generated
  static Future<OpenAIImageModel> generateImageOnPrompt(String prompt,
      {int count = 3}) async {
    return await OpenAI.instance.image.create(
      prompt: prompt,
      n: count,
      size: OpenAIImageSize.size1024,
      responseFormat: OpenAIImageResponseFormat.url,
    );
  }
}
