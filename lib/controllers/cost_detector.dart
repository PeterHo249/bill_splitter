import 'package:bill_splitter/utils/enums/locale_constant.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

double getTotalCostFromVisionText(VisionText text) {
  return getTotalCost(
    filterNumberBlocks(text),
  );
}

List<TextBlock> filterNumberBlocks(VisionText text) {
  var blocks = text.blocks;
  var numberBlocks = List<TextBlock>();
  var regex = RegExp(
    r"^((\d{1,3},)*\d+)(\.(\d+))*$",
    caseSensitive: false,
  );

  if (blocks == null || blocks.isEmpty) {
    return numberBlocks;
  }

  for (int i = 0; i < blocks.length; i++) {
    if (regex.hasMatch(blocks[i].text)) {
      numberBlocks.add(blocks[i]);
    }
  }

  return numberBlocks;
}

double getTotalCost(List<TextBlock> numberBlocks) {
  print('=========================================================');
  print('Number block count:');
  print(numberBlocks.length);
  print('=========================================================');
  if (numberBlocks.isEmpty) {
    return 0.0;
  }

  var largestBlock = numberBlocks[0];

  print('=========================================================');
  print('Number block text:');
  print(largestBlock.text);
  for (int i = 1; i < numberBlocks.length; i++) {
    print(numberBlocks[i].text);
    if (largestBlock.boundingBox.height < numberBlocks[i].boundingBox.height) {
      largestBlock = numberBlocks[i];
    }
  }
  print('=========================================================');

  var numberString = largestBlock.text;
  numberString = numberString.replaceAll(groupSeparator, "");
  numberString = numberString.replaceAll(decimalSeparator, ".");
  print(numberString);

  return double.tryParse(numberString) ?? 0.0;
}
