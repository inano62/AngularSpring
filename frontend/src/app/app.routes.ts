import { Routes } from '@angular/router';
import { LoginComponent } from './pages/login/login';
import { SettingsComponent } from './pages/settings/settings';
import { DashboardComponent } from './pages/dashboard/dashboard';

export const routes: Routes = [
  { path: '', component: LoginComponent },
  { path: 'dashboard', component: DashboardComponent },
  { path: 'settings', component: SettingsComponent },
];
