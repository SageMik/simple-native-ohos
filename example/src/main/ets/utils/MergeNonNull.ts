export function mergeNonNull<T>(obj1: T, obj2: T): T {
  const result = { ...obj1 };
  for (const key in obj2) {
    if (obj2.hasOwnProperty(key)) {
      const value = obj2[key];
      if (value) {
        result[key] = value;
      }
    }
  }
  return result as T;
}
