import { Injectable } from '@angular/core';
import { HttpClient, HttpErrorResponse } from '@angular/common/http';
import { Observable } from 'rxjs';
import { API_URL } from '../env';
import { Treatment } from './treatment.model';

@Injectable()
export class TreatmentsApiService {
  constructor(private http: HttpClient) {}

  private static _handleError(err: any) {
    return 'Error: Unable to complete request.';
  }

  // GET list of public, future events
  getTreatments(): Observable<Treatment[]> {
    return this.http.get<Treatment[]>(
      `${API_URL}treatments/106116/dog/MLPE/bright`
    );
    /*.pipe(catchError(this._handleError))*/
  }
}
