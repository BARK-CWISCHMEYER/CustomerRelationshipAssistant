import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { HttpClientModule } from '@angular/common/http';
import { AppComponent } from './app.component';
import { TreatmentsApiService } from './treatments/treatments-api.service';

@NgModule({
  declarations: [AppComponent],
  imports: [BrowserModule, HttpClientModule],
  providers: [TreatmentsApiService],
  bootstrap: [AppComponent],
})
export class AppModule {}
