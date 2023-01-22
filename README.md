# Medibank test news app
This is the news app for Medibank code test challenge.

This app is fully built with RxSwift + MVVM.

## Screenshot
<img src="https://user-images.githubusercontent.com/33548195/213873500-c2219032-da33-4309-a097-6cc2fb43c007.png" width="200" /> <img src="https://user-images.githubusercontent.com/33548195/213873634-22b3cf7a-9609-4947-8c53-9f331471d823.png" width="200" />

<img src="https://user-images.githubusercontent.com/33548195/213873625-01c269b0-3f15-408e-956d-5779e285ed5f.png" width="200" /> <img src="https://user-images.githubusercontent.com/33548195/213873630-adeedd0d-6a16-464f-8091-f9866c6f63bb.png" width="200" />

## Screen recording
https://youtu.be/uHojtg30Xsk


## How to run
You need to add a key.plist file in order to run the app and add `apiKey` as key and you api key as value

Get your api key from https://newsapi.org

## Code coverage
Tests covered all business logic (`viewModel` class).

Services class are not tested because not much logic inside and don't want to test apple's code.

![CleanShot 2023-01-23 at 01 41 25@2x](https://user-images.githubusercontent.com/33548195/213921725-11537def-69ce-4fec-a637-687d7cd10132.png)


## Future improvement
1. use `Swinject` to do dependency injection to avoid passing dependency everywhere.
2. use `Yogakit` or some other UI framwork to avoid using tidious autolayout code.
3. use `moya` to make api call easier and more testable.
4. include some generic type for `NewsResponse` object.
