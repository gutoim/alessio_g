1. Which two Flutter apps are yours, and what exactly was your role in them (solo, team lead, part of a team)? Please send store links.
Last apps I worked on as a contractor
- Christianity Today (2026)
    - part of a team with 2 Flutter devs
    - https://apps.apple.com/us/app/christianity-today/id6761113218
- Swift Medical (2024 - 2025) - Tech Lead
    - leading a team of 7-10 Flutter devs
    - https://swiftmedical.com/

Apps that I fully own (Flutter, Firebase, store publishing)
- Asclepios - available only in Spain
    - https://apps.apple.com/app/asclepios/id6745820339
    - https://play.google.com/store/apps/details?id=io.asclepios.asclepios_app
- Foodlink
    - https://apps.apple.com/es/app/foodlink-for-business/id6443556416
    - https://play.google.com/store/apps/details?id=ro.appstack.smartmenu
- NOMP - beta
    - https://apps.apple.com/us/app/nomp-not-on-my-phone/id6756650360
    - https://play.google.com/store/apps/details?id=com.wiseeyesopen.nomp
- Padel Match for players - beta
    - https://apps.apple.com/es/app/padel-match-for-players/id6755791363
    - https://play.google.com/store/apps/details?id=ro.appstack.padelmatch_app


2. Which state management do you usually use, and why?
I am using BLoC (Cubit for simple screens / widgets) for state management. Best for keeping logic out of UI and they are very easy to test (using bloc_test)

3. I hand over a documented OpenAPI spec. How do you build your API client from it (generated or written by hand), and what do you do when the spec changes in the middle of a project?
I am building API clients in Flutter using Dio and Retrofit packages. I have used code generation tools, but now with Claude Code it is handy to generate endpoints and DTO classes from the endpoint definitions.
If the spec changes mid-project, I regenerate and review the diff.
Now if the app is already in production, then the app should support backward compatibility. This involves API versioning (backend) and local database migrations if local storage is needed. 

4. How do you handle auth tokens (storage, refresh, logout when a token expires)?
Dio supports interceptor concept. This can be used to manipulate the request / response.
One usage is to add the token to authenticated requests. Auth token and refresh token are kept in phone secure storage.
When auth token expires the app will not logout, but it will try to get a new auth token using the refresh token. If refresh fails, then delete tokens from secure storage and take user to login screen.

5. What's your time zone, and when are you usually reachable?
I'm living in Spain, thus I am CET. I am available Monday-Friday, 9:00 to 18:00, but preferably before 14:00.

6. A client asks: "How long will the app take?" How do you come up with an estimate for your Flutter part?
It depends on the type of the app. For example if you need camera manipulation, live streaming, on device ML, then this is more time consuming.
But for a regular app, these are the main things I am considering:
- is design ready
- number of screens and features
- custom UI
- number of endpoints, is API ready
- push notifications
- deep links
- offline support (maybe the most expensive)
- extra security
- in app payments / subscriptions
- deploy on stores
I estimate each feature separately, add a buffer, and give a range instead of a fixed date.