# تحسينات نظام التخزين المؤقت (Caching) في التطبيق

## المشكلة الأصلية
كان التطبيق يرسل طلبات API جديدة في كل مرة يتنقل فيها المستخدم بين الصفحات، مما يؤدي إلى:
- استهلاك غير ضروري للبيانات
- بطء في التحميل
- تجربة مستخدم سيئة

## الحلول المطبقة

### 1. تطبيق نظام التخزين المؤقت في الكيوبيتس

#### Books Cubit
- إضافة متغيرات cache: `_cachedBooks`, `_lastFetchTime`
- إضافة فترة انتهاء للكاش: 15 دقيقة
- تحسين دالة `fetchBooks()` لتدعم force refresh
- إضافة دالة `refreshBooks()` للتحديث
- إضافة دالة `clearCache()` لمسح الكاش

#### Favorites Cubit
- نفس التحسينات المطبقة على Books Cubit
- دعم للتحديث بعد إضافة/حذف المفضلات

### 2. تحويل الكيوبيتس إلى Global Providers

تم تحديث `main.dart` لتضمين:
```dart
MultiBlocProvider(
  providers: [
    BlocProvider<BooksCubit>(create: (_) => BooksCubit()),
    BlocProvider<FavoriteCubit>(create: (_) => FavoriteCubit(...)),
  ],
  child: MaterialApp(...),
)
```

### 3. إضافة Pull-to-Refresh

#### في شاشة الكتب:
- `RefreshIndicator` مع دالة `_refreshBooks()`
- دعم التمرير حتى لو كانت القائمة فارغة

#### في شاشة المفضلات:
- نفس التحسينات مع دالة `_refreshFavorites()`

### 4. إنشاء خدمة Cache منفصلة

إنشاء `CacheService` في `lib/src/services/cache_service.dart`:
- Singleton pattern للاستخدام في التطبيق كله
- دعم التخزين في SharedPreferences
- إدارة timestamps لفترات انتهاء الصلاحية
- دوال منفصلة للكتب والمفضلات

## الميزات الجديدة

### 1. Smart Caching
- البيانات تُحمل من الكاش إذا كانت صالحة
- الطلبات تُرسل فقط عند الحاجة أو انتهاء صلاحية الكاش

### 2. Force Refresh
```dart
// تحديث إجباري من الـ API
booksCubit.fetchBooks(forceRefresh: true);
favoriteCubit.getFavorites(forceRefresh: true);
```

### 3. Pull-to-Refresh
- المستخدم يمكنه سحب الشاشة لأسفل للتحديث
- تجربة مستخدم محسنة مع مؤشر التحديث

### 4. إدارة الحالة المحسنة
- الكيوبيتس تبقى حية أثناء التنقل
- لا يتم فقدان البيانات عند العودة للصفحة

## استخدام النظام الجديد

### للكتب:
```dart
// تحميل الكتب (سيستخدم الكاش إذا توفر)
context.read<BooksCubit>().fetchBooks();

// تحديث إجباري
context.read<BooksCubit>().refreshBooks();

// مسح الكاش
context.read<BooksCubit>().clearCache();
```

### للمفضلات:
```dart
// تحميل المفضلات
context.read<FavoriteCubit>().getFavorites();

// تحديث إجباري
context.read<FavoriteCubit>().refreshFavorites();

// مسح الكاش
context.read<FavoriteCubit>().clearCache();
```

## فوائد التحسينات

1. **تحسين الأداء**: تقليل طلبات API غير الضرورية
2. **توفير البيانات**: استخدام أقل للإنترنت
3. **تجربة مستخدم أفضل**: تحميل أسرع للبيانات المحفوظة
4. **المرونة**: إمكانية التحديث عند الحاجة
5. **الاستقرار**: عدم فقدان البيانات أثناء التنقل

## ملاحظات مهمة

- فترة انتهاء الكاش: 15 دقيقة (قابلة للتعديل)
- يتم مسح الكاش تلقائياً عند انتهاء الصلاحية
- البيانات تُحفظ في SharedPreferences للاستمرارية
- دعم كامل للـ error handling

## التطوير المستقبلي

يمكن إضافة:
- إعدادات مخصصة لفترات انتهاء الكاش
- ضغط البيانات قبل التخزين
- إحصائيات استخدام الكاش
- تحديث تلقائي في الخلفية 