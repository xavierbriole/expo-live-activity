#!/bin/bash

# Script pour gérer le versioning et publier sur GitHub Packages
# Usage: ./scripts/publish.sh [patch|minor|major]

set -e

# Couleurs pour les messages
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Type de version (patch par défaut)
VERSION_TYPE=${1:-patch}

# Vérifier que le repo est propre
if [[ -n $(git status -s) ]]; then
  echo -e "${RED}❌ Le repository a des changements non commités${NC}"
  echo "Veuillez commit ou stash vos changements avant de publier"
  exit 1
fi

# Vérifier qu'on est sur la branche main/master
CURRENT_BRANCH=$(git branch --show-current)
if [[ "$CURRENT_BRANCH" != "main" && "$CURRENT_BRANCH" != "master" ]]; then
  echo -e "${RED}⚠️  Vous n'êtes pas sur la branche main/master${NC}"
  read -p "Voulez-vous continuer ? (y/N) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
  fi
fi

echo -e "${BLUE} Incrémentation de la version ($VERSION_TYPE)...${NC}"
npm version $VERSION_TYPE --no-git-tag-version

NEW_VERSION=$(node -p "require('./package.json').version")
echo -e "${GREEN}✅ Nouvelle version: $NEW_VERSION${NC}"

echo -e "${BLUE}📝 Commit de la nouvelle version...${NC}"
git add package.json
git commit -m "chore: bump version to $NEW_VERSION"

echo -e "${BLUE}🏷️  Création du tag...${NC}"
git tag "v$NEW_VERSION"

echo -e "${BLUE}⬆️  Push vers GitHub...${NC}"
git push origin $CURRENT_BRANCH
git push origin "v$NEW_VERSION"

echo -e "${BLUE}📤 Publication sur GitHub Packages...${NC}"
npm publish

echo -e "${GREEN}✨ Succès ! Package @xavierbriole/expo-live-activity@$NEW_VERSION publié${NC}"
echo -e "${GREEN}Pour l'installer: npm install @xavierbriole/expo-live-activity@$NEW_VERSION${NC}"
