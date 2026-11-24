# jambomama_nigeria_admin_portal

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Firebase Storage image CORS

Flutter Web downloads Firebase Storage images from the browser, so the Storage
bucket must allow the dashboard origins. Apply the bucket-level CORS policy
after authenticating the Google Cloud CLI:

```powershell
gcloud storage buckets update gs://jambo-mama-nigeria.appspot.com --cors-file=storage.cors.json
```

Add any custom dashboard domain to `storage.cors.json` before applying the
policy. This is a one-time bucket configuration; deploying Firebase Hosting
alone does not apply it.
