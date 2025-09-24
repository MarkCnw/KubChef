import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  Image,
  TouchableOpacity,
  FlatList,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';

const mockRecipeDetails = {
  '1': {
    title: 'Mediterranean Vegetable Stir Fry',
    cookTime: '25 min',
    prepTime: '15 min',
    servings: 4,
    difficulty: 'Easy',
    rating: 4.8,
    reviews: 156,
    image: 'https://via.placeholder.com/400x300/4CAF50/FFFFFF?text=Mediterranean+Stir+Fry',
    description: 'A colorful and healthy Mediterranean-inspired stir fry packed with fresh vegetables and aromatic herbs.',
    ingredients: [
      { id: '1', name: 'Large tomatoes', amount: '2', unit: 'pieces' },
      { id: '2', name: 'Medium onions', amount: '1', unit: 'piece' },
      { id: '3', name: 'Bell peppers', amount: '2', unit: 'pieces' },
      { id: '4', name: 'Garlic cloves', amount: '3', unit: 'pieces' },
      { id: '5', name: 'Olive oil', amount: '3', unit: 'tbsp' },
      { id: '6', name: 'Dried oregano', amount: '1', unit: 'tsp' },
      { id: '7', name: 'Salt', amount: '1/2', unit: 'tsp' },
      { id: '8', name: 'Black pepper', amount: '1/4', unit: 'tsp' },
    ],
    steps: [
      { id: '1', step: 'Wash and chop all vegetables into bite-sized pieces.' },
      { id: '2', step: 'Heat olive oil in a large pan over medium-high heat.' },
      { id: '3', step: 'Add onions and cook for 2-3 minutes until translucent.' },
      { id: '4', step: 'Add bell peppers and cook for 3-4 minutes.' },
      { id: '5', step: 'Add garlic and cook for 1 minute until fragrant.' },
      { id: '6', step: 'Add tomatoes, oregano, salt, and pepper.' },
      { id: '7', step: 'Cook for 5-7 minutes until vegetables are tender but still crisp.' },
      { id: '8', step: 'Serve immediately while hot. Enjoy!' },
    ],
    nutrition: {
      calories: 145,
      protein: '4g',
      carbs: '18g',
      fat: '8g',
      fiber: '6g',
    },
    tags: ['Vegetarian', 'Gluten-Free', 'Dairy-Free', 'Mediterranean'],
  },
  '2': {
    title: 'Fresh Garden Salsa',
    cookTime: '10 min',
    prepTime: '10 min',
    servings: 6,
    difficulty: 'Easy',
    rating: 4.6,
    reviews: 89,
    image: 'https://via.placeholder.com/400x300/FF9800/FFFFFF?text=Garden+Salsa',
    description: 'A fresh and zesty salsa perfect for chips, tacos, or as a side dish.',
    ingredients: [
      { id: '1', name: 'Large tomatoes', amount: '4', unit: 'pieces' },
      { id: '2', name: 'Red onion', amount: '1/2', unit: 'piece' },
      { id: '3', name: 'Bell pepper', amount: '1', unit: 'piece' },
      { id: '4', name: 'Lime juice', amount: '2', unit: 'tbsp' },
      { id: '5', name: 'Cilantro', amount: '1/4', unit: 'cup' },
      { id: '6', name: 'Salt', amount: '1/2', unit: 'tsp' },
    ],
    steps: [
      { id: '1', step: 'Dice tomatoes and remove seeds if desired.' },
      { id: '2', step: 'Finely chop red onion and bell pepper.' },
      { id: '3', step: 'Chop cilantro leaves finely.' },
      { id: '4', step: 'Combine all vegetables in a bowl.' },
      { id: '5', step: 'Add lime juice and salt.' },
      { id: '6', step: 'Mix well and let sit for 10 minutes to meld flavors.' },
      { id: '7', step: 'Taste and adjust seasoning as needed.' },
      { id: '8', step: 'Serve with tortilla chips or your favorite dish.' },
    ],
    nutrition: {
      calories: 25,
      protein: '1g',
      carbs: '6g',
      fat: '0g',
      fiber: '2g',
    },
    tags: ['Vegan', 'Gluten-Free', 'Dairy-Free', 'Low-Calorie'],
  },
  '3': {
    title: 'Roasted Vegetable Medley',
    cookTime: '45 min',
    prepTime: '15 min',
    servings: 4,
    difficulty: 'Medium',
    rating: 4.7,
    reviews: 203,
    image: 'https://via.placeholder.com/400x300/2196F3/FFFFFF?text=Roasted+Vegetables',
    description: 'Perfectly roasted vegetables with herbs and spices, great as a side dish or main course.',
    ingredients: [
      { id: '1', name: 'Bell peppers', amount: '3', unit: 'pieces' },
      { id: '2', name: 'Large onions', amount: '2', unit: 'pieces' },
      { id: '3', name: 'Garlic cloves', amount: '6', unit: 'pieces' },
      { id: '4', name: 'Olive oil', amount: '1/4', unit: 'cup' },
      { id: '5', name: 'Fresh rosemary', amount: '2', unit: 'sprigs' },
      { id: '6', name: 'Thyme', amount: '1', unit: 'tsp' },
      { id: '7', name: 'Salt', amount: '1', unit: 'tsp' },
      { id: '8', name: 'Black pepper', amount: '1/2', unit: 'tsp' },
    ],
    steps: [
      { id: '1', step: 'Preheat oven to 425°F (220°C).' },
      { id: '2', step: 'Cut vegetables into uniform pieces for even cooking.' },
      { id: '3', step: 'Toss vegetables with olive oil in a large bowl.' },
      { id: '4', step: 'Add herbs, salt, and pepper, mix well.' },
      { id: '5', step: 'Spread vegetables in a single layer on a baking sheet.' },
      { id: '6', step: 'Roast for 25-30 minutes, stirring once halfway through.' },
      { id: '7', step: 'Continue roasting until vegetables are tender and golden.' },
      { id: '8', step: 'Serve hot as a side dish or over rice/quinoa.' },
    ],
    nutrition: {
      calories: 180,
      protein: '3g',
      carbs: '20g',
      fat: '11g',
      fiber: '7g',
    },
    tags: ['Vegan', 'Gluten-Free', 'Dairy-Free', 'Paleo'],
  },
};

export default function RecipeDetailScreen({ route }) {
  const { recipe } = route.params;
  const [activeTab, setActiveTab] = useState('ingredients');
  const [checkedIngredients, setCheckedIngredients] = useState({});
  const [completedSteps, setCompletedSteps] = useState({});

  const recipeDetails = mockRecipeDetails[recipe.id] || recipe;

  const toggleIngredient = (id) => {
    setCheckedIngredients(prev => ({
      ...prev,
      [id]: !prev[id]
    }));
  };

  const toggleStep = (id) => {
    setCompletedSteps(prev => ({
      ...prev,
      [id]: !prev[id]
    }));
  };

  const renderIngredient = ({ item }) => (
    <TouchableOpacity
      style={styles.ingredientItem}
      onPress={() => toggleIngredient(item.id)}
    >
      <Ionicons
        name={checkedIngredients[item.id] ? "checkbox" : "square-outline"}
        size={24}
        color={checkedIngredients[item.id] ? "#4CAF50" : "#ccc"}
      />
      <View style={styles.ingredientContent}>
        <Text style={[
          styles.ingredientText,
          checkedIngredients[item.id] && styles.checkedIngredient
        ]}>
          {item.amount} {item.unit} {item.name}
        </Text>
      </View>
    </TouchableOpacity>
  );

  const renderStep = ({ item, index }) => (
    <TouchableOpacity
      style={styles.stepItem}
      onPress={() => toggleStep(item.id)}
    >
      <View style={styles.stepNumber}>
        <Text style={styles.stepNumberText}>{index + 1}</Text>
        {completedSteps[item.id] && (
          <View style={styles.stepCheck}>
            <Ionicons name="checkmark" size={16} color="#fff" />
          </View>
        )}
      </View>
      <Text style={[
        styles.stepText,
        completedSteps[item.id] && styles.completedStep
      ]}>
        {item.step}
      </Text>
    </TouchableOpacity>
  );

  return (
    <ScrollView style={styles.container}>
      <Image source={{ uri: recipeDetails.image }} style={styles.headerImage} />
      
      <View style={styles.content}>
        <Text style={styles.title}>{recipeDetails.title}</Text>
        <Text style={styles.description}>{recipeDetails.description}</Text>
        
        <View style={styles.metadataContainer}>
          <View style={styles.metadataItem}>
            <Ionicons name="time-outline" size={20} color="#4CAF50" />
            <View>
              <Text style={styles.metadataLabel}>Cook Time</Text>
              <Text style={styles.metadataValue}>{recipeDetails.cookTime}</Text>
            </View>
          </View>
          <View style={styles.metadataItem}>
            <Ionicons name="people-outline" size={20} color="#4CAF50" />
            <View>
              <Text style={styles.metadataLabel}>Servings</Text>
              <Text style={styles.metadataValue}>{recipeDetails.servings}</Text>
            </View>
          </View>
          <View style={styles.metadataItem}>
            <Ionicons name="bar-chart-outline" size={20} color="#4CAF50" />
            <View>
              <Text style={styles.metadataLabel}>Difficulty</Text>
              <Text style={styles.metadataValue}>{recipeDetails.difficulty}</Text>
            </View>
          </View>
          <View style={styles.metadataItem}>
            <Ionicons name="star" size={20} color="#FFD700" />
            <View>
              <Text style={styles.metadataLabel}>Rating</Text>
              <Text style={styles.metadataValue}>{recipeDetails.rating}</Text>
            </View>
          </View>
        </View>

        <View style={styles.tabContainer}>
          <TouchableOpacity
            style={[styles.tab, activeTab === 'ingredients' && styles.activeTab]}
            onPress={() => setActiveTab('ingredients')}
          >
            <Text style={[styles.tabText, activeTab === 'ingredients' && styles.activeTabText]}>
              Ingredients
            </Text>
          </TouchableOpacity>
          <TouchableOpacity
            style={[styles.tab, activeTab === 'instructions' && styles.activeTab]}
            onPress={() => setActiveTab('instructions')}
          >
            <Text style={[styles.tabText, activeTab === 'instructions' && styles.activeTabText]}>
              Instructions
            </Text>
          </TouchableOpacity>
          <TouchableOpacity
            style={[styles.tab, activeTab === 'nutrition' && styles.activeTab]}
            onPress={() => setActiveTab('nutrition')}
          >
            <Text style={[styles.tabText, activeTab === 'nutrition' && styles.activeTabText]}>
              Nutrition
            </Text>
          </TouchableOpacity>
        </View>

        {activeTab === 'ingredients' && (
          <View style={styles.tabContent}>
            <FlatList
              data={recipeDetails.ingredients}
              renderItem={renderIngredient}
              keyExtractor={(item) => item.id}
              scrollEnabled={false}
            />
          </View>
        )}

        {activeTab === 'instructions' && (
          <View style={styles.tabContent}>
            <FlatList
              data={recipeDetails.steps}
              renderItem={renderStep}
              keyExtractor={(item) => item.id}
              scrollEnabled={false}
            />
          </View>
        )}

        {activeTab === 'nutrition' && (
          <View style={styles.tabContent}>
            <View style={styles.nutritionGrid}>
              <View style={styles.nutritionItem}>
                <Text style={styles.nutritionValue}>{recipeDetails.nutrition.calories}</Text>
                <Text style={styles.nutritionLabel}>Calories</Text>
              </View>
              <View style={styles.nutritionItem}>
                <Text style={styles.nutritionValue}>{recipeDetails.nutrition.protein}</Text>
                <Text style={styles.nutritionLabel}>Protein</Text>
              </View>
              <View style={styles.nutritionItem}>
                <Text style={styles.nutritionValue}>{recipeDetails.nutrition.carbs}</Text>
                <Text style={styles.nutritionLabel}>Carbs</Text>
              </View>
              <View style={styles.nutritionItem}>
                <Text style={styles.nutritionValue}>{recipeDetails.nutrition.fat}</Text>
                <Text style={styles.nutritionLabel}>Fat</Text>
              </View>
              <View style={styles.nutritionItem}>
                <Text style={styles.nutritionValue}>{recipeDetails.nutrition.fiber}</Text>
                <Text style={styles.nutritionLabel}>Fiber</Text>
              </View>
            </View>
            
            <View style={styles.tagsContainer}>
              <Text style={styles.tagsTitle}>Tags</Text>
              <View style={styles.tagsList}>
                {recipeDetails.tags?.map((tag, index) => (
                  <View key={index} style={styles.tag}>
                    <Text style={styles.tagText}>{tag}</Text>
                  </View>
                ))}
              </View>
            </View>
          </View>
        )}
      </View>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f5f5f5',
  },
  headerImage: {
    width: '100%',
    height: 250,
  },
  content: {
    backgroundColor: '#fff',
    marginTop: -20,
    borderTopLeftRadius: 20,
    borderTopRightRadius: 20,
    padding: 20,
    flex: 1,
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#333',
    marginBottom: 10,
  },
  description: {
    fontSize: 16,
    color: '#666',
    lineHeight: 24,
    marginBottom: 20,
  },
  metadataContainer: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    justifyContent: 'space-between',
    marginBottom: 30,
  },
  metadataItem: {
    flexDirection: 'row',
    alignItems: 'center',
    width: '48%',
    marginBottom: 15,
  },
  metadataLabel: {
    fontSize: 12,
    color: '#666',
    marginLeft: 10,
  },
  metadataValue: {
    fontSize: 16,
    fontWeight: 'bold',
    color: '#333',
    marginLeft: 10,
  },
  tabContainer: {
    flexDirection: 'row',
    borderBottomWidth: 1,
    borderBottomColor: '#e0e0e0',
    marginBottom: 20,
  },
  tab: {
    flex: 1,
    paddingVertical: 15,
    alignItems: 'center',
  },
  activeTab: {
    borderBottomWidth: 2,
    borderBottomColor: '#4CAF50',
  },
  tabText: {
    fontSize: 16,
    color: '#666',
  },
  activeTabText: {
    color: '#4CAF50',
    fontWeight: 'bold',
  },
  tabContent: {
    minHeight: 200,
  },
  ingredientItem: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: 12,
    borderBottomWidth: 1,
    borderBottomColor: '#f0f0f0',
  },
  ingredientContent: {
    flex: 1,
    marginLeft: 15,
  },
  ingredientText: {
    fontSize: 16,
    color: '#333',
  },
  checkedIngredient: {
    textDecorationLine: 'line-through',
    color: '#999',
  },
  stepItem: {
    flexDirection: 'row',
    alignItems: 'flex-start',
    paddingVertical: 15,
    borderBottomWidth: 1,
    borderBottomColor: '#f0f0f0',
  },
  stepNumber: {
    width: 30,
    height: 30,
    borderRadius: 15,
    backgroundColor: '#4CAF50',
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: 15,
    position: 'relative',
  },
  stepNumberText: {
    color: '#fff',
    fontSize: 14,
    fontWeight: 'bold',
  },
  stepCheck: {
    position: 'absolute',
    top: -5,
    right: -5,
    width: 20,
    height: 20,
    borderRadius: 10,
    backgroundColor: '#2E7D32',
    justifyContent: 'center',
    alignItems: 'center',
  },
  stepText: {
    flex: 1,
    fontSize: 16,
    color: '#333',
    lineHeight: 24,
  },
  completedStep: {
    color: '#999',
    textDecorationLine: 'line-through',
  },
  nutritionGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    justifyContent: 'space-between',
    marginBottom: 30,
  },
  nutritionItem: {
    width: '30%',
    alignItems: 'center',
    backgroundColor: '#f8f8f8',
    borderRadius: 10,
    padding: 20,
    marginBottom: 10,
  },
  nutritionValue: {
    fontSize: 20,
    fontWeight: 'bold',
    color: '#4CAF50',
    marginBottom: 5,
  },
  nutritionLabel: {
    fontSize: 12,
    color: '#666',
    textAlign: 'center',
  },
  tagsContainer: {
    marginTop: 20,
  },
  tagsTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    color: '#333',
    marginBottom: 10,
  },
  tagsList: {
    flexDirection: 'row',
    flexWrap: 'wrap',
  },
  tag: {
    backgroundColor: '#E8F5E8',
    borderRadius: 15,
    paddingHorizontal: 12,
    paddingVertical: 6,
    marginRight: 10,
    marginBottom: 10,
  },
  tagText: {
    fontSize: 12,
    color: '#4CAF50',
    fontWeight: 'bold',
  },
});