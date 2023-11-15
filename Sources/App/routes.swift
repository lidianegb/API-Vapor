import Fluent
import Vapor

func routes(_ app: Application) throws {
    
    // MARK: Basic Auth MiddleWare
    
    let basicAuthMiddleWare = User.authenticator()
    let guardMiddleware = User.guardMiddleware()
    let basicAuthGroup = app.routes.grouped(basicAuthMiddleWare)
    
    // MARK: Token Auth
    let tokenAuthMiddleWare = Token.authenticator()
    let tokenAuthGroup = app.routes.grouped(tokenAuthMiddleWare, guardMiddleware)
    
    // MARK: Admin auth
    
    let adminMiddleware = CheckAdminMiddleware()
    let adminTokenAuthGroup = app.routes.grouped(tokenAuthMiddleWare, adminMiddleware)
    
    // MARK: ControllerS
    
    let authController = AuthController()
    let userController = UserController()
    let publicationController = PublicationController()
    let resourceController = ResourceController()
    let appointmentController = AppointmentController()
    
    // MARK: Registered Auth Routes
    
    basicAuthGroup.post("\(RoutesEnum.login.rawValue)", use: authController.loginHandler(_:))
    
    // MARK: Registered User routes
    
    basicAuthGroup.post("\(RoutesEnum.users.rawValue)", "\(RoutesEnum.register.rawValue)", use: userController.create(_:))
    tokenAuthGroup.get("\(RoutesEnum.users.rawValue)", "\(RoutesEnum.profile.rawValue)", use: userController.get(_:))
    adminTokenAuthGroup.get("\(RoutesEnum.users.rawValue)", use: userController.getAll(_:))
    tokenAuthGroup.patch("\(RoutesEnum.users.rawValue)", "\(RoutesEnum.profile.rawValue)", "\(RoutesEnum.update.rawValue)", use: userController.update(_:))
    adminTokenAuthGroup.patch("\(RoutesEnum.users.rawValue)", "\(RoutesEnum.schedule.rawValue)", "\(RoutesEnum.update.rawValue)", use: userController.updateSchedule(_:))
    adminTokenAuthGroup.delete("\(RoutesEnum.users.rawValue)", "\(RoutesEnum.delete.rawValue)", "\(RouterParameter.id.rawValue)", use: userController.delete(_:))
    tokenAuthGroup.get("\(RoutesEnum.monitors.rawValue)", use: userController.getMonitors(_:))
    adminTokenAuthGroup.get("\(RoutesEnum.users.rawValue)", "\(RoutesEnum.profile.rawValue)", "\(RoutesEnum.search.rawValue)", "\(RouterParameter.term.rawValue)", use: userController.search(_:))
    
    // MARK: Appointments Routes
    
    tokenAuthGroup.post("\(RoutesEnum.appointments.rawValue)", use: appointmentController.create(_:))
    tokenAuthGroup.get("\(RoutesEnum.appointments.rawValue)", "\(RouterParameter.id.rawValue)", use: appointmentController.get(_:))
    tokenAuthGroup.get("\(RoutesEnum.appointments.rawValue)", "\(RoutesEnum.list.rawValue)", use: appointmentController.getAll(_:))
    tokenAuthGroup.patch("\(RoutesEnum.appointments.rawValue)", "\(RouterParameter.id.rawValue)", use: appointmentController.update(_:))
    tokenAuthGroup.delete("\(RoutesEnum.appointments.rawValue)", "\(RouterParameter.id.rawValue)", use: appointmentController.delete(_:))
    tokenAuthGroup.get("\(RoutesEnum.appointments.rawValue)", "\(RoutesEnum.filter.rawValue)", "\(RouterParameter.status.rawValue)", use: appointmentController.getByStatus(_:))
    
    // MARK: Publications Routes
    
    adminTokenAuthGroup.post("\(RoutesEnum.publications.rawValue)", use: publicationController.create(_:))
    basicAuthGroup.get("\(RoutesEnum.publications.rawValue)", "\(RouterParameter.id.rawValue)", use: publicationController.get(_:))
    basicAuthGroup.get("\(RoutesEnum.publications.rawValue)", "\(RoutesEnum.list.rawValue)", use: publicationController.getAll(_:))
    adminTokenAuthGroup.patch("\(RoutesEnum.publications.rawValue)", "\(RouterParameter.id.rawValue)", use: publicationController.update(_:))
    adminTokenAuthGroup.delete("\(RoutesEnum.publications.rawValue)", "\(RouterParameter.id.rawValue)", use: publicationController.delete(_:))
    basicAuthGroup.get("\(RoutesEnum.publications.rawValue)", "\(RoutesEnum.search.rawValue)", "\(RouterParameter.term.rawValue)", use: publicationController.search(_:))
    
    // MARK: Resources Routes
    
    adminTokenAuthGroup.post("\(RoutesEnum.resources.rawValue)", use: resourceController.create(_:))
    basicAuthGroup.get("\(RoutesEnum.resources.rawValue)", "\(RouterParameter.id.rawValue)", use: resourceController.get(_:))
    basicAuthGroup.get("\(RoutesEnum.resources.rawValue)", "\(RoutesEnum.list.rawValue)", use: resourceController.getAll(_:))
    basicAuthGroup.get("\(RoutesEnum.resources.rawValue)", "\(RoutesEnum.filter.rawValue)", "\(RouterParameter.type.rawValue)", use: resourceController.getByType(_:))
    adminTokenAuthGroup.patch("\(RoutesEnum.resources.rawValue)", "\(RouterParameter.id.rawValue)", use: resourceController.update(_:))
    adminTokenAuthGroup.delete("\(RoutesEnum.resources.rawValue)", "\(RouterParameter.id.rawValue)", use: resourceController.delete(_:))
}
