import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  FlatList,
  TouchableOpacity,
  Image,
  TextInput,
  Alert,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';

const mockRecipes = [
  {
    id: '1',
    title: 'Mediterranean Vegetable Stir Fry',
    cookTime: '25 min',
    servings: 4,
    difficulty: 'Easy',
    rating: 4.8,
    image: 'https://via.placeholder.com/300x200/4CAF50/FFFFFF?text=Recipe+1',
    ingredients: ['Tomatoes', 'Onions', 'Bell Peppers', 'Garlic'],
  },
  {
    id: '2',
    title: 'Fresh Garden Salsa',
    cookTime: '10 min',
    servings: 6,
    difficulty: 'Easy',
    rating: 4.6,
    image: 'https://via.placeholder.com/300x200/FF9800/FFFFFF?text=Recipe+2',
    ingredients: ['Tomatoes', 'Onions', 'Bell Peppers'],
  },
  {
    id: '3',
    title: 'Roasted Vegetable Medley',
    cookTime: '45 min',
    servings: 4,
    difficulty: 'Medium',
    rating: 4.7,
    image: 'https://via.placeholder.com/300x200/2196F3/FFFFFF?text=Recipe+3',
    ingredients: ['Bell Peppers', 'Onions', 'Garlic'],
  },
];

export default function ResultsScreen({ route, navigation }) {
  const { ingredients: initialIngredients, imageUri } = route.params;
  const [ingredients, setIngredients] = useState(initialIngredients);
  const [editingIngredient, setEditingIngredient] = useState(null);
  const [editText, setEditText] = useState('');

  const startEditing = (ingredient) => {
    setEditingIngredient(ingredient.id);
    setEditText(ingredient.name);
  };

  const saveEdit = () => {
    if (!editText.trim()) {
      Alert.alert('Error', 'Ingredient name cannot be empty');
      return;
    }
    
    setIngredients(prev =>
      prev.map(ingredient =>
        ingredient.id === editingIngredient
          ? { ...ingredient, name: editText.trim() }
          : ingredient
      )
    );
    setEditingIngredient(null);
    setEditText('');
  };

  const cancelEdit = () => {
    setEditingIngredient(null);
    setEditText('');
  };

  const removeIngredient = (id) => {
    setIngredients(prev => prev.filter(ingredient => ingredient.id !== id));
  };

  const renderIngredient = ({ item }) => (
    <View style={styles.ingredientCard}>
      {editingIngredient === item.id ? (
        <View style={styles.editContainer}>
          <TextInput
            style={styles.editInput}
            value={editText}
            onChangeText={setEditText}
            autoFocus
            onSubmitEditing={saveEdit}
          />
          <TouchableOpacity style={styles.saveButton} onPress={saveEdit}>
            <Ionicons name="checkmark" size={20} color="#4CAF50" />
          </TouchableOpacity>
          <TouchableOpacity style={styles.cancelButton} onPress={cancelEdit}>
            <Ionicons name="close" size={20} color="#f44336" />
          </TouchableOpacity>
        </View>
      ) : (
        <View style={styles.ingredientInfo}>
          <View style={styles.ingredientDetails}>
            <Text style={styles.ingredientName}>{item.name}</Text>
            <View style={styles.confidenceContainer}>
              <Text style={styles.confidenceText}>
                {Math.round(item.confidence * 100)}% confidence
              </Text>
              <View style={styles.confidenceBar}>
                <View 
                  style={[
                    styles.confidenceFill, 
                    { width: `${item.confidence * 100}%` }
                  ]} 
                />
              </View>
            </View>
          </View>
          <View style={styles.ingredientActions}>
            <TouchableOpacity 
              style={styles.editIconButton} 
              onPress={() => startEditing(item)}
            >
              <Ionicons name="pencil" size={16} color="#4CAF50" />
            </TouchableOpacity>
            <TouchableOpacity 
              style={styles.deleteIconButton} 
              onPress={() => removeIngredient(item.id)}
            >
              <Ionicons name="trash" size={16} color="#f44336" />
            </TouchableOpacity>
          </View>
        </View>
      )}
    </View>
  );

  const renderRecipe = ({ item }) => (
    <TouchableOpacity
      style={styles.recipeCard}
      onPress={() => navigation.navigate('RecipeDetail', { recipe: item })}
    >
      <Image source={{ uri: item.image }} style={styles.recipeImage} />
      <View style={styles.recipeInfo}>
        <Text style={styles.recipeTitle}>{item.title}</Text>
        <View style={styles.recipeMetadata}>
          <View style={styles.metadataItem}>
            <Ionicons name="time-outline" size={16} color="#666" />
            <Text style={styles.metadataText}>{item.cookTime}</Text>
          </View>
          <View style={styles.metadataItem}>
            <Ionicons name="people-outline" size={16} color="#666" />
            <Text style={styles.metadataText}>{item.servings} servings</Text>
          </View>
          <View style={styles.metadataItem}>
            <Ionicons name="star" size={16} color="#FFD700" />
            <Text style={styles.metadataText}>{item.rating}</Text>
          </View>
        </View>
        <View style={styles.difficultyContainer}>
          <Text style={[
            styles.difficultyText,
            item.difficulty === 'Easy' ? styles.easyDifficulty :
            item.difficulty === 'Medium' ? styles.mediumDifficulty :
            styles.hardDifficulty
          ]}>
            {item.difficulty}
          </Text>
        </View>
      </View>
    </TouchableOpacity>
  );

  return (
    <View style={styles.container}>
      <View style={styles.detectedSection}>
        <View style={styles.sectionHeader}>
          <Text style={styles.sectionTitle}>Detected Ingredients</Text>
          <Text style={styles.editHint}>Tap to edit if incorrect</Text>
        </View>
        <FlatList
          data={ingredients}
          renderItem={renderIngredient}
          keyExtractor={(item) => item.id}
          horizontal
          showsHorizontalScrollIndicator={false}
          contentContainerStyle={styles.ingredientsList}
        />
      </View>

      <View style={styles.recipesSection}>
        <Text style={styles.sectionTitle}>Recipe Suggestions</Text>
        <FlatList
          data={mockRecipes}
          renderItem={renderRecipe}
          keyExtractor={(item) => item.id}
          showsVerticalScrollIndicator={false}
          contentContainerStyle={styles.recipesList}
        />
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f5f5f5',
  },
  detectedSection: {
    backgroundColor: '#fff',
    paddingVertical: 20,
    marginBottom: 10,
  },
  sectionHeader: {
    paddingHorizontal: 20,
    marginBottom: 15,
  },
  sectionTitle: {
    fontSize: 20,
    fontWeight: 'bold',
    color: '#333',
  },
  editHint: {
    fontSize: 14,
    color: '#666',
    marginTop: 5,
  },
  ingredientsList: {
    paddingHorizontal: 20,
  },
  ingredientCard: {
    backgroundColor: '#f8f8f8',
    borderRadius: 10,
    padding: 15,
    marginRight: 15,
    minWidth: 180,
    borderWidth: 1,
    borderColor: '#e0e0e0',
  },
  editContainer: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  editInput: {
    flex: 1,
    borderWidth: 1,
    borderColor: '#4CAF50',
    borderRadius: 5,
    paddingHorizontal: 10,
    paddingVertical: 5,
    fontSize: 16,
  },
  saveButton: {
    marginLeft: 10,
    padding: 5,
  },
  cancelButton: {
    marginLeft: 5,
    padding: 5,
  },
  ingredientInfo: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'flex-start',
  },
  ingredientDetails: {
    flex: 1,
  },
  ingredientName: {
    fontSize: 16,
    fontWeight: 'bold',
    color: '#333',
    marginBottom: 8,
  },
  confidenceContainer: {
    flex: 1,
  },
  confidenceText: {
    fontSize: 12,
    color: '#666',
    marginBottom: 4,
  },
  confidenceBar: {
    height: 4,
    backgroundColor: '#e0e0e0',
    borderRadius: 2,
  },
  confidenceFill: {
    height: '100%',
    backgroundColor: '#4CAF50',
    borderRadius: 2,
  },
  ingredientActions: {
    flexDirection: 'row',
    marginLeft: 10,
  },
  editIconButton: {
    padding: 5,
    marginRight: 5,
  },
  deleteIconButton: {
    padding: 5,
  },
  recipesSection: {
    flex: 1,
    backgroundColor: '#fff',
    paddingTop: 20,
  },
  recipesList: {
    paddingHorizontal: 20,
  },
  recipeCard: {
    backgroundColor: '#fff',
    borderRadius: 15,
    marginBottom: 20,
    elevation: 3,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.25,
    shadowRadius: 3.84,
  },
  recipeImage: {
    width: '100%',
    height: 200,
    borderTopLeftRadius: 15,
    borderTopRightRadius: 15,
  },
  recipeInfo: {
    padding: 15,
  },
  recipeTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    color: '#333',
    marginBottom: 10,
  },
  recipeMetadata: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: 10,
  },
  metadataItem: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  metadataText: {
    fontSize: 14,
    color: '#666',
    marginLeft: 4,
  },
  difficultyContainer: {
    alignItems: 'flex-start',
  },
  difficultyText: {
    fontSize: 12,
    paddingHorizontal: 8,
    paddingVertical: 4,
    borderRadius: 10,
    fontWeight: 'bold',
  },
  easyDifficulty: {
    backgroundColor: '#E8F5E8',
    color: '#4CAF50',
  },
  mediumDifficulty: {
    backgroundColor: '#FFF3E0',
    color: '#FF9800',
  },
  hardDifficulty: {
    backgroundColor: '#FFEBEE',
    color: '#f44336',
  },
});