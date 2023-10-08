import 'package:dart_openai/dart_openai.dart';

class OpenAiService{
  List<OpenAIModelModel> models = [];

  init() async {
    models = await OpenAI.instance.model.list();
  }
  Future<OpenAIModelModel> retrieveModel(String id)async{
    return await OpenAI.instance.model.retrieve(id);
  }
  Future<OpenAICompletionModel> getCompletion(String prompt,String model)async{
    return await OpenAI.instance.completion.create(
      model: model,
      prompt: prompt,
      maxTokens: 20,
      temperature: 0.5,
      n: 1,
      stop: ["\n"],
      echo: true,
    )
  }
  Future<Stream<OpenAICompletionModel>> streamCompletion(String prompt,String model)async{
    return OpenAI.instance.completion.createStream(
      model: model,
      prompt: prompt,
      maxTokens: 100,
      temperature: 0.5,
      topP: 1,
    );
  }
}