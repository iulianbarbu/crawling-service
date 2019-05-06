/**
 * Autogenerated by Avro
 * 
 * DO NOT EDIT DIRECTLY
 */
package org.apache.hadoop.mapreduce.jobhistory;  
@SuppressWarnings("all")
@org.apache.avro.specific.AvroGenerated
public class JobInfoChange extends org.apache.avro.specific.SpecificRecordBase implements org.apache.avro.specific.SpecificRecord {
  public static final org.apache.avro.Schema SCHEMA$ = new org.apache.avro.Schema.Parser().parse("{\"type\":\"record\",\"name\":\"JobInfoChange\",\"namespace\":\"org.apache.hadoop.mapreduce.jobhistory\",\"fields\":[{\"name\":\"jobid\",\"type\":\"string\"},{\"name\":\"submitTime\",\"type\":\"long\"},{\"name\":\"launchTime\",\"type\":\"long\"}]}");
  public static org.apache.avro.Schema getClassSchema() { return SCHEMA$; }
  @Deprecated public java.lang.CharSequence jobid;
  @Deprecated public long submitTime;
  @Deprecated public long launchTime;

  /**
   * Default constructor.
   */
  public JobInfoChange() {}

  /**
   * All-args constructor.
   */
  public JobInfoChange(java.lang.CharSequence jobid, java.lang.Long submitTime, java.lang.Long launchTime) {
    this.jobid = jobid;
    this.submitTime = submitTime;
    this.launchTime = launchTime;
  }

  public org.apache.avro.Schema getSchema() { return SCHEMA$; }
  // Used by DatumWriter.  Applications should not call. 
  public java.lang.Object get(int field$) {
    switch (field$) {
    case 0: return jobid;
    case 1: return submitTime;
    case 2: return launchTime;
    default: throw new org.apache.avro.AvroRuntimeException("Bad index");
    }
  }
  // Used by DatumReader.  Applications should not call. 
  @SuppressWarnings(value="unchecked")
  public void put(int field$, java.lang.Object value$) {
    switch (field$) {
    case 0: jobid = (java.lang.CharSequence)value$; break;
    case 1: submitTime = (java.lang.Long)value$; break;
    case 2: launchTime = (java.lang.Long)value$; break;
    default: throw new org.apache.avro.AvroRuntimeException("Bad index");
    }
  }

  /**
   * Gets the value of the 'jobid' field.
   */
  public java.lang.CharSequence getJobid() {
    return jobid;
  }

  /**
   * Sets the value of the 'jobid' field.
   * @param value the value to set.
   */
  public void setJobid(java.lang.CharSequence value) {
    this.jobid = value;
  }

  /**
   * Gets the value of the 'submitTime' field.
   */
  public java.lang.Long getSubmitTime() {
    return submitTime;
  }

  /**
   * Sets the value of the 'submitTime' field.
   * @param value the value to set.
   */
  public void setSubmitTime(java.lang.Long value) {
    this.submitTime = value;
  }

  /**
   * Gets the value of the 'launchTime' field.
   */
  public java.lang.Long getLaunchTime() {
    return launchTime;
  }

  /**
   * Sets the value of the 'launchTime' field.
   * @param value the value to set.
   */
  public void setLaunchTime(java.lang.Long value) {
    this.launchTime = value;
  }

  /** Creates a new JobInfoChange RecordBuilder */
  public static org.apache.hadoop.mapreduce.jobhistory.JobInfoChange.Builder newBuilder() {
    return new org.apache.hadoop.mapreduce.jobhistory.JobInfoChange.Builder();
  }
  
  /** Creates a new JobInfoChange RecordBuilder by copying an existing Builder */
  public static org.apache.hadoop.mapreduce.jobhistory.JobInfoChange.Builder newBuilder(org.apache.hadoop.mapreduce.jobhistory.JobInfoChange.Builder other) {
    return new org.apache.hadoop.mapreduce.jobhistory.JobInfoChange.Builder(other);
  }
  
  /** Creates a new JobInfoChange RecordBuilder by copying an existing JobInfoChange instance */
  public static org.apache.hadoop.mapreduce.jobhistory.JobInfoChange.Builder newBuilder(org.apache.hadoop.mapreduce.jobhistory.JobInfoChange other) {
    return new org.apache.hadoop.mapreduce.jobhistory.JobInfoChange.Builder(other);
  }
  
  /**
   * RecordBuilder for JobInfoChange instances.
   */
  public static class Builder extends org.apache.avro.specific.SpecificRecordBuilderBase<JobInfoChange>
    implements org.apache.avro.data.RecordBuilder<JobInfoChange> {

    private java.lang.CharSequence jobid;
    private long submitTime;
    private long launchTime;

    /** Creates a new Builder */
    private Builder() {
      super(org.apache.hadoop.mapreduce.jobhistory.JobInfoChange.SCHEMA$);
    }
    
    /** Creates a Builder by copying an existing Builder */
    private Builder(org.apache.hadoop.mapreduce.jobhistory.JobInfoChange.Builder other) {
      super(other);
    }
    
    /** Creates a Builder by copying an existing JobInfoChange instance */
    private Builder(org.apache.hadoop.mapreduce.jobhistory.JobInfoChange other) {
            super(org.apache.hadoop.mapreduce.jobhistory.JobInfoChange.SCHEMA$);
      if (isValidValue(fields()[0], other.jobid)) {
        this.jobid = data().deepCopy(fields()[0].schema(), other.jobid);
        fieldSetFlags()[0] = true;
      }
      if (isValidValue(fields()[1], other.submitTime)) {
        this.submitTime = data().deepCopy(fields()[1].schema(), other.submitTime);
        fieldSetFlags()[1] = true;
      }
      if (isValidValue(fields()[2], other.launchTime)) {
        this.launchTime = data().deepCopy(fields()[2].schema(), other.launchTime);
        fieldSetFlags()[2] = true;
      }
    }

    /** Gets the value of the 'jobid' field */
    public java.lang.CharSequence getJobid() {
      return jobid;
    }
    
    /** Sets the value of the 'jobid' field */
    public org.apache.hadoop.mapreduce.jobhistory.JobInfoChange.Builder setJobid(java.lang.CharSequence value) {
      validate(fields()[0], value);
      this.jobid = value;
      fieldSetFlags()[0] = true;
      return this; 
    }
    
    /** Checks whether the 'jobid' field has been set */
    public boolean hasJobid() {
      return fieldSetFlags()[0];
    }
    
    /** Clears the value of the 'jobid' field */
    public org.apache.hadoop.mapreduce.jobhistory.JobInfoChange.Builder clearJobid() {
      jobid = null;
      fieldSetFlags()[0] = false;
      return this;
    }

    /** Gets the value of the 'submitTime' field */
    public java.lang.Long getSubmitTime() {
      return submitTime;
    }
    
    /** Sets the value of the 'submitTime' field */
    public org.apache.hadoop.mapreduce.jobhistory.JobInfoChange.Builder setSubmitTime(long value) {
      validate(fields()[1], value);
      this.submitTime = value;
      fieldSetFlags()[1] = true;
      return this; 
    }
    
    /** Checks whether the 'submitTime' field has been set */
    public boolean hasSubmitTime() {
      return fieldSetFlags()[1];
    }
    
    /** Clears the value of the 'submitTime' field */
    public org.apache.hadoop.mapreduce.jobhistory.JobInfoChange.Builder clearSubmitTime() {
      fieldSetFlags()[1] = false;
      return this;
    }

    /** Gets the value of the 'launchTime' field */
    public java.lang.Long getLaunchTime() {
      return launchTime;
    }
    
    /** Sets the value of the 'launchTime' field */
    public org.apache.hadoop.mapreduce.jobhistory.JobInfoChange.Builder setLaunchTime(long value) {
      validate(fields()[2], value);
      this.launchTime = value;
      fieldSetFlags()[2] = true;
      return this; 
    }
    
    /** Checks whether the 'launchTime' field has been set */
    public boolean hasLaunchTime() {
      return fieldSetFlags()[2];
    }
    
    /** Clears the value of the 'launchTime' field */
    public org.apache.hadoop.mapreduce.jobhistory.JobInfoChange.Builder clearLaunchTime() {
      fieldSetFlags()[2] = false;
      return this;
    }

    @Override
    public JobInfoChange build() {
      try {
        JobInfoChange record = new JobInfoChange();
        record.jobid = fieldSetFlags()[0] ? this.jobid : (java.lang.CharSequence) defaultValue(fields()[0]);
        record.submitTime = fieldSetFlags()[1] ? this.submitTime : (java.lang.Long) defaultValue(fields()[1]);
        record.launchTime = fieldSetFlags()[2] ? this.launchTime : (java.lang.Long) defaultValue(fields()[2]);
        return record;
      } catch (Exception e) {
        throw new org.apache.avro.AvroRuntimeException(e);
      }
    }
  }
}
