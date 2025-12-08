import { Injectable } from "@angular/core";
import { HttpClient } from "@angular/common/http";
import { Observable } from "rxjs";
import { Patient } from "../models/patient";
import { executeSchedule } from "rxjs/internal/util/executeSchedule";

@Injectable({
    providedIn: 'root'
})
export class PatientService {
    private baseUrl = 'http://localhost:8080/api/patients';

    constructor(private http: HttpClient){}
    
    getAll():Observable<Patient[]>{
        return this.http.get<Patient[]>(this.baseUrl);
    }
    create(patient:Patient):Observable<Patient>{
        return this.http.post<Patient>(this.baseUrl,patient);
    }
    update(id:number,patient:Patient):Observable<Patient>{
        return this.http.put<Patient>(`${this.baseUrl}/${id}`,patient);
    }
    delete(id:number):Observable<void>{
        return this.http.delete<void>(`${this.baseUrl}/${id}`);
    }
}