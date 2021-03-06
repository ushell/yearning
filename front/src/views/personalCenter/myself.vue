<template>
    <div>
        <div>
            <Form ref="userForm" label-position="right">
                <FormItem :label="$t('general.name')" prop="name">
                    <div>
                        <span>{{ userForm.Username }}</span>
                    </div>
                </FormItem>
                <FormItem :label="$t('general.real')" prop="name">
                    <div>
                        <span>{{ userForm.RealName }}</span>
                    </div>
                </FormItem>
                <FormItem :label="$t('general.department')">
                    <span>{{ userForm.Department }}</span>
                </FormItem>
                <FormItem :label="$t('general.role')">
                    <span>{{ userForm.Rule }}</span>
                </FormItem>
                <FormItem :label="$t('general.mail')">
                    <span>{{ userForm.Email }}</span>
                </FormItem>
                <Button type="warning" size="small" @click="edit_password=true">{{$t('general.change_password')}}
                </Button>
                <Button type="primary" size="small" @click="openMailChange" class="margin-left-10">
                    {{$t('dash.edit_permissions')}}
                </Button>
                <Button type="success" size="small" @click="openPerChange" class="margin-left-10">
                    {{$t('general.show_permissions')}}
                </Button>
            </Form>
        </div>

        <Modal v-model="editEmailModal" :width="500" @on-ok="saveEmail">
            <h3 slot="header" style="color:#2D8CF0">{{$t('dash.edit_permissions')}}</h3>
            <Form :label-width="100" label-position="right">
                <FormItem :label="$t('general.mail')">
                    <Input v-model="editEmailForm.Email"></Input>
                </FormItem>
                <FormItem :label="$t('general.real')">
                    <Input v-model="editEmailForm.RealName"></Input>
                </FormItem>
            </Form>
        </Modal>

        <edit_rule :is_open="is_open" :username="userForm.Username" :group_list="group_list"
                   :group_props="group_props" @cancel="cancel"></edit_rule>
        <edit_password :is_open="edit_password" :username="userForm.Username" @cancel="cancel_password"></edit_password>
    </div>
</template>

<script lang="ts">
    import axios from 'axios'
    import edit_password from "@/components/edit_password.vue";
    import edit_rule from "@/components/edit_rule.vue";
    import att_mixins from "@/mixins/att";
    import {Component, Mixins} from "vue-property-decorator";

    @Component({components: {edit_password, edit_rule}})
    export default class myself extends Mixins(att_mixins) {
        editEmailModal = false;
        editEmailForm = {
            Email: '',
            RealName: ''
        };
        userForm = {
            Username: '',
            ID: '',
            Password: '',
            Rule: '',
            Department: '',
            RealName: '',
            Email: ''
        };

        $config: any;

        openMailChange() {
            this.editEmailModal = true;
            this.editEmailForm = this.userForm
        }

        openPerChange() {
            this.is_open = true
        }

        saveEmail() {
            axios.put(`${this.$config.url}/user/edit/mail`, {
                'mail': this.editEmailForm.Email,
                'username': this.userForm.Username,
                'real': this.editEmailForm.RealName
            })
                .then(res => {
                    this.$config.notice(res.data);
                    sessionStorage.setItem('real_name', this.editEmailForm.RealName)
                })
                .catch(error => {
                    this.$config.err_notice(this, error)
                });
        }

        init() {
            axios.put(`${this.$config.url}/dash/userinfo`)
                .then(res => {
                    this.userForm = res.data.u;
                    this.group_props = res.data.p;
                    this.group_list = res.data.g;
                    this.$store.state.stmt = res.data.s.Stmt === 0;
                })
        }

        cancel() {
            this.is_open = false;
        }

        mounted() {
            this.init()
        }
    }
</script>

<style lang="less">
    @import '../../styles/own-space.less';
    @import '../../styles/common.less';
</style>
