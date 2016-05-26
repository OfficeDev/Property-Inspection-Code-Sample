package com.canviz.repairapp.graph;

import com.microsoft.graph.extensions.ConversationThread;
import com.microsoft.services.orc.core.ODataBaseEntity;

/**
 * Created by Tyler on 11/27/15.
 */
public class Conversation extends ODataBaseEntity {

    public Conversation(){
        setODataType("#Microsoft.Graph.Conversation");
    }

    private String id;

    /**
     * Gets the id.
     *
     * @return the String
     */
    public String getId() {
        return this.id;
    }

    /**
     * Sets the id.
     *
     * @param value the String
     */
    public void setId(String value) {
        this.id = value;
        valueChanged("id", value);

    }

    private String topic;

    /**
     * Gets the topic.
     *
     * @return the String
     */
    public String getTopic() {
        return this.topic;
    }

    /**
     * Sets the topic.
     *
     * @param value the String
     */
    public void setTopic(String value) {
        this.topic = value;
        valueChanged("topic", value);

    }

    private Boolean hasAttachments;

    /**
     * Gets the has Attachments.
     *
     * @return the Boolean
     */
    public Boolean getHasAttachments() {
        return this.hasAttachments;
    }

    /**
     * Sets the has Attachments.
     *
     * @param value the Boolean
     */
    public void setHasAttachments(Boolean value) {
        this.hasAttachments = value;
        valueChanged("hasAttachments", value);

    }

    private java.util.Calendar lastDeliveryTime;

    /**
     * Gets the last Delivery Time.
     *
     * @return the java.util.Calendar
     */
    public java.util.Calendar getLastDeliveryTime() {
        return this.lastDeliveryTime;
    }

    /**
     * Sets the last Delivery Time.
     *
     * @param value the java.util.Calendar
     */
    public void setLastDeliveryTime(java.util.Calendar value) {
        this.lastDeliveryTime = value;
        valueChanged("lastDeliveryTime", value);

    }


    private java.util.List<String> uniqueSenders = null;



    /**
     * Gets the unique Senders.
     *
     * @return the java.util.List<String>
     */
    public java.util.List<String> getUniqueSenders() {
        return this.uniqueSenders;
    }

    /**
     * Sets the unique Senders.
     *
     * @param value the java.util.List<String>
     */
    public void setUniqueSenders(java.util.List<String> value) {
        this.uniqueSenders = value;
        valueChanged("UniqueSenders", value);

    }

    private String preview;

    /**
     * Gets the preview.
     *
     * @return the String
     */
    public String getPreview() {
        return this.preview;
    }

    /**
     * Sets the preview.
     *
     * @param value the String
     */
    public void setPreview(String value) {
        this.preview = value;
        valueChanged("Preview", value);

    }


    private java.util.List<ConversationThread> threads = null;



    /**
     * Gets the threads.
     *
     * @return the java.util.List<ConversationThread>
     */
    public java.util.List<ConversationThread> getThreads() {
        return this.threads;
    }

    /**
     * Sets the threads.
     *
     * @param value the java.util.List<ConversationThread>
     */
    public void setThreads(java.util.List<ConversationThread> value) {
        this.threads = value;
        valueChanged("threads", value);

    }
}