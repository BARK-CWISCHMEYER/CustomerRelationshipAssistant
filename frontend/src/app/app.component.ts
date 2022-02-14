import { Component, OnInit, OnDestroy } from '@angular/core';
import { Subscription } from 'rxjs';
import { TreatmentsApiService } from './treatments/treatments-api.service';
import { Treatment } from './treatments/treatment.model';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css'],
})
export class AppComponent implements OnInit, OnDestroy {
  title = 'app';

  treatmentListSubs: Subscription;
  treatmentList: Treatment[];

  constructor(private treatmentsApi: TreatmentsApiService) {
    this.treatmentList = new Array();
    this.treatmentListSubs = new Subscription();
  }

  ngOnInit() {
    this.treatmentListSubs = this.treatmentsApi
      .getTreatments()
      .subscribe((res) => {
        this.treatmentList = res;
      }, console.error);
  }

  ngOnDestroy() {
    this.treatmentListSubs.unsubscribe();
  }
}
