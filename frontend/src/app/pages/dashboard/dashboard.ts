import { Component,OnInit } from '@angular/core';
import { PatientService } from '../../services/patient.service';
import { Patient } from '../../models/patient';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-dashboard',
  standalone:true,
  imports:[CommonModule],
  templateUrl: './dashboard.html',
  styleUrl: './dashboard.scss',
})
export class DashboardComponent {
  patients:Patient[] = [];

  constructor(private patientService:PatientService){}

  ngOnInit():void {
    this.load();
  }
  load(){
    this.patientService.getAll().subscribe((data) => {
      this.patients = data;
    });
  }
}
