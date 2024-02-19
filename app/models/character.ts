interface CharacterAttributes {
  name: string;
  profession: string;
  skills: SkillAttributes[];
  strength: number;
  health: number;
  charisma: number;
  perception: number;
  intelligence: number;
  dexterity: number;
  salary: number;
  food: number;
}

interface SkillAttributes {
  name: string;
  description: string;
}
