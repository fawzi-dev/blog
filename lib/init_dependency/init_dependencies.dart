
// Refereing to the import file 
part of 'init_dependency_imports.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencie() async {
  _initAuth();
  _initBlog();
  final supabase = await Supabase.initialize(
      url: AppSecrets.url, anonKey: AppSecrets.anonKy);

  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;

  serviceLocator.registerLazySingleton(() => Hive.box(name: 'blogs'));

  serviceLocator.registerLazySingleton(() => supabase.client);

  serviceLocator.registerLazySingleton(() => AppUserCubit());

  serviceLocator.registerFactory(() => InternetConnection());

  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(
      serviceLocator(),
    ),
  );
}

void _initAuth() {
  serviceLocator
    ..registerFactory<AuthRemotedDataSource>(
      () => AuthRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        authRemotedDataSource: serviceLocator(),
        connectionChecker: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserSignUp(
        authRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserLogin(
        authRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => CurrentUser(
        serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userLogin: serviceLocator(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}

void _initBlog() {
  serviceLocator
    ..registerFactory<BlogRemoteDataSources>(
      () => BlogRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<BlogLocalDateSource>(
      () => BlogLocalDataSourceImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImpl(
        blogRemoteDataSources: serviceLocator(),
        blogLocalDataSources: serviceLocator(),
        connectionChecker: serviceLocator(),
      ),
    )
    ..registerFactory<UploadBlog>(
      () => UploadBlog(
        serviceLocator(),
      ),
    )
    ..registerFactory<GetBlogs>(
      () => GetBlogs(
        blogRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => BlogBloc(
        uploadBlog: serviceLocator(),
        getBlogs: serviceLocator(),
      ),
    );
}
