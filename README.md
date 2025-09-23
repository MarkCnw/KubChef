# KubChef - AI-Powered Recipe Finder

KubChef is a React Native mobile application that uses AI to analyze ingredients from photos and suggest recipes. The app provides a clean, intuitive flow from scanning ingredients to viewing detailed recipe instructions.

## Features

### 🔍 **Scan Screen**
- **Camera Integration**: Use your phone's camera to capture ingredients
- **Gallery Support**: Select images from your photo library
- **Clear UI**: Prominent scan area with visual guidance
- **Analyze Button**: Process images with AI ingredient detection
- **Loading States**: Visual feedback during image analysis
- **Error Handling**: User-friendly error messages

### 📋 **Results Screen**
- **Detected Ingredients**: View AI-identified ingredients with confidence scores
- **Ingredient Editing**: Tap to edit ingredients if AI misidentifies them
- **Confidence Bars**: Visual indication of AI detection accuracy
- **Recipe Suggestions**: Browse recipes based on detected ingredients
- **Recipe Cards**: Clean layout with images, cook time, servings, and ratings
- **Easy Navigation**: Tap cards to view detailed recipes

### 📖 **Recipe Detail Screen**
- **Large Recipe Images**: High-quality visuals for each recipe
- **Complete Information**: Cook time, servings, difficulty, and ratings
- **Tabbed Interface**: Switch between Ingredients, Instructions, and Nutrition
- **Interactive Ingredients**: Check off ingredients as you gather them
- **Step-by-Step Instructions**: Numbered cooking steps with progress tracking
- **Nutrition Information**: Detailed nutritional breakdown
- **Recipe Tags**: Dietary information (Vegetarian, Gluten-Free, etc.)

## Technical Implementation

- **Framework**: React Native with Expo
- **Navigation**: React Navigation for smooth screen transitions
- **Camera**: Expo Camera for ingredient scanning
- **UI Components**: Custom styled components with Ionicons
- **State Management**: React hooks for component state
- **Mock Data**: Realistic sample recipes and ingredients for MVP

## Getting Started

```bash
# Install dependencies
npm install

# Start the development server
npm start

# Run on specific platform
npm run android  # Android
npm run ios      # iOS
npm run web      # Web browser
```

## MVP Design Goals ✅

- **Clean Flow**: Scan → Results → Recipe navigation
- **Clear Camera Area**: Prominent scanning interface with visual guides
- **Prominent Analyze Button**: Easy-to-find action button
- **Readable Recipe Cards**: Large images and clear text
- **Detailed Recipe View**: Time, servings, ingredients, and steps clearly displayed
- **Loading/Error States**: Proper user feedback during operations
- **Ingredient Editing**: Allow users to correct AI misidentifications

## Future Enhancements

- Real AI integration for ingredient detection
- Recipe favoriting and history
- Nutritional goal tracking
- Shopping list generation
- Social recipe sharing
- Voice-guided cooking instructions